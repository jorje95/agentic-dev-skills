---
name: mobile-development
description: >-
  React Native (TypeScript), Expo, and Kotlin mobile development workflow and performance standards (synthesized from Callstack, Vercel React Native Skills, and Official Expo SkillHub packages) covering Measure-Optimize-Remeasure, FlashList, Reanimated GPU animations, React Navigation / Expo Router, Safe Areas, and Kotlin TurboModules/Expo Modules. Use when building, updating, profiling, or debugging mobile app features.
---

# Mobile Development Skill (React Native, Expo & Kotlin)

Follow these prioritized React Native and Kotlin mobile standards (synthesized from `callstackincubator/agent-skills`, `vercel-react-native-skills`, and `expo/skills`).

## 1. Optimization Workflow (`Measure → Optimize → Re-measure → Validate`)

- Never apply speculative memoization or architectural changes for performance without measuring first (React DevTools Profiler, Hermes sampling profiler, or frame timelines).
- Validate every optimization against concrete metrics: **FPS (60/120fps)**, **TTI (startup time)**, **re-render count**, and **bundle size**.

## 2. Priority 1: List & Scroll Performance (`CRITICAL`)

- **Virtualize All Dynamic Lists (`list-performance-virtualize`)**: Never map arrays inside a `ScrollView` for dynamic/long lists. Use **`FlashList`** (note: FlashList v2 no longer requires `estimatedItemSize`) or **`FlatList`**.
- **Memoize List Items & Stabilize Callbacks (`list-performance-item-memo`)**:
  - Wrap list item components in `React.memo` and keep props primitive/stable.
  - Avoid inline style objects (`style={{ ... }}`) and inline arrow callbacks inside `renderItem`.
  - Pass `getItemType` to `FlashList` for heterogeneous feeds so native view recycling stays fast.
- **Images in Lists (`ui-expo-image`)**: Use `expo-image` (or FastImage) with caching, `recyclingKey`, and explicit dimensions instead of stock `<Image>`.

## 3. Priority 2: GPU Animations & Gestures (`HIGH`)

- **Animate Only GPU Properties (`animation-gpu-properties`)**: Run animations on the UI thread with **`react-native-reanimated`** animating `transform` and `opacity`—avoid animating `width`, `height`, `top`, or `padding` on the JS thread.
- **Derived Animation Values (`animation-derived-value`)**: Use `useDerivedValue` for computed worklet animations and `Gesture.Tap` / `react-native-gesture-handler` for coordinated touch interactions.

## 4. Priority 3: Navigation, Safe Areas & Rendering Safety (`HIGH`)

- **Native Navigators (`navigation-native-navigators`)**: Prefer native stack (`@react-navigation/native-stack` / Static API or `expo-router`) and native bottom tabs over JS-driven navigators.
- **Safe Areas & Scroll Insets (`ui-safe-area-scroll`)**:
  - Use `react-native-safe-area-context` (`useSafeAreaInsets`) or `contentInsetAdjustmentBehavior="automatic"` on `ScrollView` / `FlashList`.
  - Always set explicit `flex: 1` on screen root containers to prevent layout collapse.
- **React Native Rendering Guardrails**:
  - **Text inside `<Text>` (`rendering-text-in-text-component`)**: Never render raw strings outside a `<Text>` component (causes native crash).
  - **Avoid Falsy `&&` (`rendering-no-falsy-and`)**: Never write `{count && <Badge />}` or `{str && <View />}`—if `count` is `0` or `str` is `""`, React Native crashes attempting to render raw text in a `<View>`. Always coerce to boolean (`{count > 0 && <Badge />}` or ternary `{count ? <Badge /> : null}`).
  - **Use `Pressable` (`ui-pressable`)**: Prefer `Pressable` over legacy `TouchableOpacity`.

## 5. Native Android / Kotlin Modules (`TurboModules` / `Expo Modules`)

- Keep native bridges thin and strongly typed in TypeScript.
- Offload all blocking I/O, database, file, and crypto work to Kotlin coroutine dispatchers (`Dispatchers.IO` / `Dispatchers.Default`); never block the Android UI thread.
- Clean up native listeners, broadcast receivers, and coroutines on lifecycle destroy/unmount.
