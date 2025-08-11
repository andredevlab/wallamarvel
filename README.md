# iOS Tech Test – Implementation Plan

## Overview  
This document outlines my 4-day plan for implementing the iOS Tech Test.  
The goal is to **deliver the mandatory features by the due date (Friday)** (Hero List with pagination + Hero Detail) while showcasing architectural thinking, SOLID principles, testing practices, and modern iOS development skills.  

Each phase delivers something functional and builds incrementally on the previous work.  

---

## **Monday**  

### Phase 0 – Initial BugFix  
**Deliverables:**  
- App runs without crashes.  
- Shows hero/character list or error state with Retry button.  
- Basic logger + centralized error handling (`AppError`).  

**Purpose:**  
- Demonstrate quick problem-solving with simple, functional fixes.  
- Provide a stable baseline for future work.  

**Skills:**  
- Fast debugging and bug resolution.  
- Clear UI state management.  

---

### Phase 1 – Isolated Network Module + Tests  
**Deliverables:**  
- `NetworkCore` module (`HTTPClient`, `APIRequest`, `CharacterService`...).  
- `CharacterService` with Swift Concurrency (`async/await`).  
- Unit tests for `HTTPClient` and `CharacterService` (success, error, timeout, invalid JSON).  
- `CharacterAPI` abstraction for API fallback (Marvel + Mock/Backup).  

**Purpose:**  
- Showcase modularization and testability from the start.  
- Apply Clean Architecture by separating Data layer and injecting dependencies.  

**Skills:**  
- **Clean Architecture**: Data vs. Domain separation.  
- **SOLID**: SRP (single responsibility), DIP (dependency inversion).  
- **Design patterns**: Strategy (API fallback), Factory (request creation).  
- Testability with `URLProtocol` mocks.  

---

## **Tuesday**  

### Phase 2 – Character List with Pagination (Must)  
**Deliverables:**  
- `UITableViewDiffableDataSource` + `CellConfigurator`.  
- Controlled pagination with “Load more” footer (no infinite scroll).  
- Skeleton/loading cells on initial load.  
- Unit tests for Repository (pagination, error) and Presenter (all states).  

**Purpose:**  
- Show architectural evolution and navigation separation with Coordinator.  
- Improve UX and performance with diffable data source.  

**Skills:**  
- **Clean Architecture**: Presentation isolated from Data via Domain protocols.  
- **SOLID**: OCP (open/closed), ISP (interface segregation).  
- **Design patterns**: Coordinator (navigation), Factory (feature creation).  
- Performance-focused UI updates.  

---

## **Wednesday**  

### Phase 3 – Character Detail Screen (Must)  
**Deliverables:**  
- Navigation from list to detail via Coordinator.  
- Presenter/ViewModel + SwiftUI for details.  
- Endpoints for comics, series, or bio in specifics `Service`.  
- Loading placeholders + error state.  
- Unit tests for Presenter and networking calls.  

**Purpose:**  
- Demonstrate feature expansion while preserving architectural consistency.  
- Demonstrate SwiftUI skill
- Reuse existing infrastructure (Coordinator, Repository, Factory).  

**Skills:**  
- **Clean Architecture**: Domain-driven use cases for details.  
- **SOLID**: LSP (Liskov substitution).  
- **Design patterns**: Coordinator and Factory applied consistently.  

---

### Phase 4 – UI & Snapshot Tests  
**Deliverables:**  
- Snapshot tests for cell, list, and UI states.  
- Mocks to validate Coordinator navigation.  

**Purpose:**  
- Prevent UI regressions and validate presentation layer visually.  

**Skills:**  
-  testing with deterministic snapshots.  

---

## **Thursday**  

### Phase 5 – Nice-to-Haves + Polish  
**Deliverables:**  
- Search bar with debounce.  
- Accessibility: labels, traits and Dynamic Type.
- Micro animations for improved UX.    
- Lint/formatting adjustments, basic image caching.      

**Purpose:**  
- Show attention to UX, accessibility, and performance.  
- Demonstrate ability to integrate new tech without disrupting architecture.  

**Skills:**    
- **UX & Accessibility**: inclusive and polished design.    

---

## **Friday Morning – Final Delivery**  
- Repository with complete, tested, and documented code ready for review.  
