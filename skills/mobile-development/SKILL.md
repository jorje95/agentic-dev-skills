---
name: mobile-development
description: >-
  React Native (TypeScript) and Kotlin mobile development workflow and performance standards (based on Callstack & Expo best practices) covering UI/Hook/Service separation, React Navigation, safe areas, FPS/TTI/bundle optimization, FlashList, Reanimated, offline resilience, and Kotlin TurboModules/Expo Modules. Use when building, updating, profiling, or debugging mobile app features.
---

# Mobile Development Skill (React Native & Kotlin)

Follow these architecture and performance standards when building, optimizing, or debugging React Native mobile apps and Kotlin native bridges.

## 1. Layered Mobile Architecture

- **Screen & UI Layer**:
  - Build small, typed functional components using `StyleSheet.create` (or Unistyles/NativeWind if configured).
  - Always define explicit layout constraints (`flex: 1` on root containers) to prevent flexbox layout collapse.
  - Handle device insets using `react-native-safe-area-context` (`useSafeAreaInsets` / `SafeAreaView`) and keyboard avoidance (`react-native-keyboard-controller` or `KeyboardAvoidingView`).
- **Navigation (`React Navigation` / `Expo Router`)**:
  - Enforce end-to-end TypeScript route param typing.
  - Prefer native stack (`@react-navigation/native-stack`) and native/bottom tabs for platform-authentic transitions and gestures.
- **State, Caching & Offline Resilience**:
  - Use **TanStack Query** with persistent storage (**MMKV** / AsyncStorage) for offline-first server cache and background refetching.
  - Store sensitive tokens exclusively in encrypted storage (`expo-secure-store` / `react-native-keychain`).

## 2. Performance Optimization (`Measure → Optimize → Re-measure`)

- **FPS & Lists (CRITICAL)**:
  - Never render long or dynamic lists inside a `ScrollView`; always use **`FlashList`** or **`FlatList`** with stable `keyExtractor` and memoized item components.
  - Avoid inline object/arrow function allocations on hot list items when profiling shows cascading re-renders.
  - Use atomic state selectors (e.g., `useStore(s => s.slice)`) so components only re-render when their specific slice changes.
- **Animations & Gestures**:
  - Run all animations and gesture interactions on the UI worklet thread using **`react-native-reanimated`** and **`react-native-gesture-handler`**; never drive frame-by-frame layout changes across the JS bridge.
- **TTI & Bundle Size**:
  - Use Hermes bytecode compilation, avoid barrel-file imports (`import ... from './index'`) that defeat tree-shaking, and defer heavy non-critical initialization until after initial screen mount.

## 3. Native Android / Kotlin Modules

- When platform-specific capabilities require native Kotlin code (TurboModules / Expo Modules):
  - Keep the native bridge surface thin and strongly typed in TypeScript.
  - Execute all blocking I/O, crypto, or heavy computation on Kotlin background coroutine dispatchers (`Dispatchers.IO` / `Dispatchers.Default`), never on the Android main UI thread.
  - Respect Android Activity/Fragment lifecycle cleanup to prevent memory leaks.

## 4. Verification Checklist

1. Run TypeScript (`tsc --noEmit`) and ESLint checks.
2. Run Jest + **React Native Testing Library** tests for screens and hooks.
3. Verify both **iOS** and **Android** behavior: safe areas, hardware back button, keyboard overlap, permissions, offline state, and minimum touch target sizes (`44x44pt` / `48x48dp`).
