# Decisiones Técnicas — flutterv2_90013715


## 1. Arquitectura por Features (Feature-First)

**Decisión:** Organizar el código bajo `lib/features/<nombre_feature>/` con subdivisión interna en capas `data/`, `domain/` y `presentation/`.

**Razón:**
- Permite que el equipo trabaje en features distintas sin conflictos de merge frecuentes.
- Escala mejor que una organización por tipo de archivo (`screens/`, `models/`, `repos/`) cuando el proyecto crece.
- Facilita la eliminación de una feature completa sin tocar otras partes del sistema.

**Estructura resultante:**
```
lib/
├── core/                  # Infraestructura compartida (router, theme, services)
│   ├── router/
│   ├── services/
│   ├── providers/
│   ├── theme/
│   └── widgets/
└── features/
    ├── ecommerce/         # Flujo principal: catálogo, detalle, carrito, checkout
    │   ├── data/          # Implementaciones concretas (mock repos, modelos JSON)
    │   ├── domain/        # Entidades y contratos (interfaces) del negocio
    │   └── presentation/  # Pantallas, providers de UI, widgets
    ├── onboarding/        # Flujo de primera vez: intro + selección de intereses
    └── shop/              # Feature de tienda secundaria (catálogo alternativo)
```

---

## 2. Clean Architecture (Data / Domain / Presentation)

**Decisión:** Aplicar separación estricta en tres capas dentro de cada feature.

| Capa | Responsabilidad | Puede importar |
|---|---|---|
| `domain/` | Entidades puras + contratos (interfaces de repositorios) | Nada de Flutter ni de `data/` |
| `data/` | Implementaciones concretas de repos, modelos de red/DB | Solo `domain/` |
| `presentation/` | Pantallas, providers, widgets | Solo `domain/` + paquetes Flutter |

**Razón:** Permite cambiar la fuente de datos (mock → API real → base de datos) sin tocar la UI ni la lógica de negocio.

---

## 3. Gestión de Estado: Flutter Riverpod + Code Generation

**Paquetes:** `flutter_riverpod`, `riverpod_annotation`, `riverpod_generator`

**Decisión:** Usar Riverpod como solución de inyección de dependencias y gestión de estado reactivo. Se activa code generation (`@riverpod`) para reducir boilerplate.

**Razón:**
- Riverpod es compile-safe: errores de providers se detectan en tiempo de compilación.
- `AsyncNotifier` y `FutureProvider` ofrecen manejo nativo de estados `loading / data / error` sin código extra.
- El code generation (`build_runner`) genera el boilerplate de providers tipados.
- Compatible con testing: los providers se pueden sobrescribir fácilmente con mocks via `ProviderScope.overrides`.

**Patrones usados:**
- `@riverpod` / `FutureProvider` — para datos asíncronos (productos, tarjetas de prueba)
- `@riverpod class Notifier` — para lógica con estado mutable (carrito, proceso de pago)
- `StateProvider` — para estado UI simple (talla seleccionada, color seleccionado)

---

## 4. Modelos Inmutables: Freezed + json_serializable

**Paquetes:** `freezed_annotation`, `freezed`, `json_annotation`, `json_serializable`

**Decisión:** Todas las entidades de dominio y modelos de datos se declaran con `@freezed`.

**Razón:**
- Genera automáticamente `copyWith`, `==`, `hashCode` y `toString`.
- `fromJson`/`toJson` se generan vía `json_serializable` para serialización a SharedPreferences o red.
- Los objetos inmutables evitan bugs de mutación de estado.

---

## 5. Navegación: go_router

**Paquete:** `go_router`

**Decisión:** Usar `go_router` como solución de navegación declarativa basada en URL.

**Razón:**
- URL-based routing facilita deep linking y navegación web si el proyecto escala.
- Integración nativa con Riverpod mediante `@riverpod GoRouter appRouter(...)`.
- Soporta guards de navegación (redirect) para proteger rutas según estado de sesión (onboarding completado o no).

**Rutas definidas:**
```
/onboarding   → OnboardingScreen (primera vez)
/home         → HomeScreen (catálogo principal)
/product/:id  → ProductDetailScreen
/cart         → CartScreen
/checkout     → CheckoutScreen
```

---

## 6. Persistencia Local: SharedPreferences

**Paquete:** `shared_preferences`

**Decisión:** Usar `SharedPreferences` para cache ligero y persistencia de preferencias de usuario.

**Casos de uso:**
- Estado de onboarding completado (`hasCompletedOnboarding`)
- Cache de productos (JSON serializado) para disponibilidad offline
- Preferencia de idioma (locale seleccionado)

**Razón:** Para datos simples y pequeños, SharedPreferences es suficiente y evita introducir una dependencia de base de datos completa (Hive, SQLite). Para datos grandes o relacionales, se evaluaría Hive o Drift.

---

## 7. Internacionalización: flutter_localizations + intl

**Paquetes:** `flutter_localizations` (SDK), `intl`

**Decisión:** Configurar i18n con code generation via `flutter gen-l10n` y archivos `.arb`.

**Idiomas soportados:** Español (`es`) e Inglés (`en`).

**Razón:**
- El enfoque oficial de Flutter para i18n es robusto y sin dependencias externas.
- Los archivos `.arb` son el estándar de la industria para strings localizados.
- La generación automática (`AppLocalizations`) evita strings hardcodeados y facilita la adición de nuevos idiomas.



## Diagrama de capas

```
┌─────────────────────────────────────────┐
│           Presentation Layer            │
│  (Screens, Providers, Widgets)          │
│  ← Riverpod, Flutter, go_router        │
└────────────────┬────────────────────────┘
                 │ depende de
┌────────────────▼────────────────────────┐
│             Domain Layer                │
│  (Entities, Repository Interfaces)     │
│  ← Freezed, Dart puro                  │
└────────────────┬────────────────────────┘
                 │ implementado por
┌────────────────▼────────────────────────┐
│              Data Layer                 │
│  (Mock Repos, HTTP, SharedPreferences) │
│  ← json_serializable, http, prefs      │
└─────────────────────────────────────────┘
```
