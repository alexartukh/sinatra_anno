import {
  API_BASE_URL,
  API_ENDPOINTS,
  MESSAGE_TYPES,
  STORAGE_KEYS,
} from './config/constants'
import { authLog, decodeTokenExp, tokenSnippet } from './utils/authLog'

interface RefreshResult {
  success: boolean
  tokens?: { access: string; refresh: string }
  error?: string
}

let refreshPromise: Promise<RefreshResult> | null = null

async function handleRefresh(): Promise<RefreshResult> {
  const result = await chrome.storage.local.get([STORAGE_KEYS.REFRESH_TOKEN])
  const refreshToken = result[STORAGE_KEYS.REFRESH_TOKEN]

  if (!refreshToken) {
    await authLog.log('refresh_fail', { reason: 'no_refresh_token' })
    return { success: false, error: 'No refresh token' }
  }

  try {
    const response = await fetch(
      `${API_BASE_URL}${API_ENDPOINTS.AUTH_REFRESH}`,
      {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ refresh: refreshToken }),
      },
    )

    if (!response.ok) {
      const data = await response.json().catch(() => ({}))
      const tokensCleared = response.status === 401 || response.status === 403
      // Only clear tokens on definitive auth failure, not transient errors
      if (tokensCleared) {
        await chrome.storage.local.remove([
          STORAGE_KEYS.ACCESS_TOKEN,
          STORAGE_KEYS.REFRESH_TOKEN,
        ])
      }
      await authLog.log('refresh_fail', {
        status: response.status,
        error: data.error || null,
        tokensCleared,
      })
      return {
        success: false,
        error: data.error || `Refresh failed (${response.status})`,
      }
    }

    const tokens = await response.json()
    await chrome.storage.local.set({
      [STORAGE_KEYS.ACCESS_TOKEN]: tokens.access,
      [STORAGE_KEYS.REFRESH_TOKEN]: tokens.refresh,
    })
    await authLog.log('refresh_ok', {
      accessSnippet: tokenSnippet(tokens.access),
      accessExp: decodeTokenExp(tokens.access),
      refreshSnippet: tokenSnippet(tokens.refresh),
    })
    return {
      success: true,
      tokens: { access: tokens.access, refresh: tokens.refresh },
    }
  } catch {
    // Network error — don't clear tokens, they may still be valid
    await authLog.log('refresh_network_error', { error: 'Network error' })
    return { success: false, error: 'Network error' }
  }
}

chrome.runtime.onMessage.addListener((message, _sender, sendResponse) => {
  if (message.type === MESSAGE_TYPES.REFRESH_TOKENS) {
    if (!refreshPromise) {
      refreshPromise = handleRefresh().finally(() => {
        refreshPromise = null
      })
    }
    refreshPromise.then(sendResponse)
    return true // Keep message channel open for async response
  }
})

chrome.action.onClicked.addListener((tab) => {
  if (!tab.id) return
  chrome.scripting.executeScript({
    target: { tabId: tab.id },
    files: ['overlay.js'],
  })
})
