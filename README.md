# FitAplikacja — Przegląd ćwiczeń i plany treningowe

Aplikacja mobilna stworzona w Flutterze, pozwalająca na:
- przeglądanie ćwiczeń z publicznego API,
- filtrowanie i wyszukiwanie ćwiczeń,
- tworzenie własnych planów treningowych,
- realizację treningu krok po kroku ,
- działanie w trybie offline poprzez lokalną persystencję danych (Hive),
- podział logiki zgodnie z MVVM.

Aplikacja została przygotowana jako projekt zaliczeniowy z pełnym designem w Figma, implementacją REST API, obsługą błędów oraz separacją warstw.

---

##  Funkcjonalności

###  Przegląd ćwiczeń
- lista ćwiczeń pobieranych z API,
- wyszukiwarka,
- filtrowanie po częściach ciała,
- ekran szczegółów ćwiczenia.

###  Offline mode
Aplikacja zapisuje pobrane ćwiczenia w Hive, dzięki czemu:
- jeśli użytkownik nie ma internetu - aplikacja nadal działa,
- lista ćwiczeń pobiera się z cache.

###  Plany treningowe
- możliwość tworzenia, edytowania i usuwania planów,
- dodawanie ćwiczeń do planu,
- przypisywanie dnia tygodnia,
- notatki, liczba serii i powtórzeń.

### Tryb treningu 
- wykonywanie planu krok po kroku,
- licznik serii,
- timer odpoczynku,
- pomijanie ćwiczeń,
- zakończenie treningu.

###  Nawigacja
- dolna nawigacja: **Home / Ćwiczenia / Plany**,
- ekran szczegółów otwierany po kliknięciu elementu na liście,
- spójny i czytelny UX zgodny z projektem Figma.

---

## Użyte API
Aplikacja korzysta z:
**ExerciseDB API**  
Dokumentacja:  
https://v2.exercisedb.dev/docs

Używane endpointy:
- `/api/v1/exercises` — lista ćwiczeń 
- `/api/v1/exercises/{id}` — szczegóły ćwiczenia

Pobierane pola (min. 5 wymaganych):
- `exerciseId`
- `name`
- `imageUrl`
- `bodyParts`
- `equipments`
- `keywords`
- `targetMuscles`
- `secondaryMuscles`

---

## Architektura aplikacji
Projekt wykorzystuje architekturę:

### **MVVM + Repository + DataSource**

lib/
├─ core/
├─ data/
│ ├─ datasources/ (API + Hive)
│ ├─ models/
│ ├─ repositories/
├─ presentation/
│ ├─ screens/
│ ├─ viewmodels/
│ ├─ widgets/

Każda warstwa jest odseparowana:
- **View** → widoki i UI
- **ViewModel** → logika, obsługa API, filtrowania, błędów
- **Repository** → łączenie API i cache
- **DataSource** → API + lokalny Hive
- **Model** → struktury danych

---

## Technologie & biblioteki

- Flutter 3.x
- Dart
- Dio (komunikacja HTTP)
- Provider (zarządzanie stanem)
- Hive + hive_flutter (lokalna baza danych offline)
- Material 3 UI
- Navigator / MaterialPageRoute
- Timer & async

---

##  Instalacja i uruchomienie

### 1️⃣ Sklonuj repozytorium
```bash
git clone <link do repo>
cd <nazwa folderu>
2️⃣ Pobierz zależności
bash
Skopiuj kod
flutter pub get
3️⃣ Uruchom aplikację
bash
Skopiuj kod
flutter run
