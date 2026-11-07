# Chrome Extension - Restructured Architecture

This chrome extension has been restructured following best practices, DRY principles, and single responsibility principles.

## 📁 Project Structure

```
src/
├── components/           # Reusable UI components
│   ├── App.tsx          # Main application component
│   ├── auth/            # Authentication related components
│   │   ├── Authentication.tsx
│   │   └── index.ts
│   ├── task/            # Task management components
│   │   ├── TaskInput.tsx
│   │   ├── TaskDisplay.tsx
│   │   ├── TaskManager.tsx
│   │   └── index.ts
│   ├── ui/              # Generic UI components
│   │   ├── button.tsx
│   │   ├── Loading.tsx
│   │   ├── ErrorDisplay.tsx
│   │   └── index.ts
│   └── index.ts
├── services/            # Business logic and API services
│   ├── api.ts           # Generic API service
│   ├── auth.ts          # Authentication service
│   ├── task.ts          # Task management service
│   ├── theme.ts         # Theme management service
│   └── index.ts
├── hooks/               # Custom React hooks
│   ├── useAuth.ts       # Authentication state management
│   ├── useTask.ts       # Task state management
│   └── index.ts
├── utils/               # Utility functions
│   ├── errors.ts        # Error handling utilities
│   └── index.ts
├── config/              # Configuration and constants
│   └── constants.ts     # API endpoints, storage keys, etc.
├── lib/                 # External library utilities
│   └── utils.ts         # Utility functions (existing)
├── newtab.tsx           # New tab page entry point
├── overlay.tsx          # Content script overlay entry point
├── background.ts        # Service worker
└── index.ts             # Main exports
```

## 🏗️ Architecture Principles

### Single Responsibility Principle
- Each service handles one specific domain (auth, tasks, API, theme)
- Components have single, focused responsibilities
- Hooks manage specific pieces of state

### DRY (Don't Repeat Yourself)
- Eliminated code duplication between `newtab.tsx` and `overlay.tsx`
- Shared components used across different contexts
- Centralized API logic and error handling

### Separation of Concerns
- **Services**: Handle business logic and API communication
- **Components**: Handle UI rendering and user interactions
- **Hooks**: Manage state and side effects
- **Utils**: Provide reusable utility functions

## 🔧 Key Services

### API Service (`services/api.ts`)
- Centralized HTTP client with error handling
- Automatic token management
- Type-safe API responses

### Authentication Service (`services/auth.ts`)
- Token management (get, set, remove)
- Magic link and verification workflows
- Authentication state management

### Task Service (`services/task.ts`)
- Task CRUD operations
- Handles task-specific API calls
- Type-safe task operations

### Theme Service (`services/theme.ts`)
- Centralized theme management
- Consistent styling across components
- Body style application

## 🎣 Custom Hooks

### useAuth Hook
- Manages authentication state
- Handles login/logout workflows
- Provides loading and error states

### useTask Hook
- Manages task state and operations
- Handles API errors with automatic token refresh
- Provides CRUD operations for tasks

## 🧩 Component Architecture

### App Component
- Main application entry point
- Handles routing between auth and task views
- Supports different variants (newtab, overlay)

### Authentication Component
- Complete auth workflow (email → code → verification)
- Integrated error handling
- Loading states for better UX

### TaskManager Component
- Complete task management interface
- Switches between task display and input
- Integrated error handling and loading states

## 🎨 UI Components

- **Button**: Reusable button with variants and sizes
- **Loading**: Consistent loading indicator
- **ErrorDisplay**: Standardized error display with actions
- **TaskInput**: Reusable task input form
- **TaskDisplay**: Task display with completion functionality

## 📦 Benefits of This Structure

1. **Maintainability**: Clear separation makes code easier to understand and modify
2. **Reusability**: Components and services can be easily reused
3. **Testability**: Each piece can be tested in isolation
4. **Scalability**: Easy to add new features without affecting existing code
5. **Type Safety**: Comprehensive TypeScript types throughout
6. **Error Handling**: Centralized and consistent error management
7. **Performance**: Optimized with proper React patterns and hooks

## 🚀 Usage

The restructured code maintains the same functionality while providing:
- Better code organization
- Improved error handling
- Consistent theming
- Type safety
- Easier maintenance and extension

Both `newtab.tsx` and `overlay.tsx` now use the same underlying components and services, eliminating duplication while maintaining their distinct presentation styles.
