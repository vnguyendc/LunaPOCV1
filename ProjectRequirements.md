# Luna: Comprehensive Hormone Tracking DEMO App

## Project Instructions
1. Work on one core feature at a time based on my instructions
2. Follow Philosophy of Software Design principles by Ousterhout, John
3. This first iteration is going to be a DEMO app, so any data created should be mock data, including adding, updating, deleting hormone data, log data, user data, etc.
4. Keep it simple and light. 
5. UI aesthetics should be modern, feminine, UX should be simple. 
6. Update MEMORY_BANK.md after major changes.

## Core Vision

**"Complete hormone tracking that adapts to YOUR unique patterns"**

Luna focuses on comprehensive hormone monitoring with intelligent cycle detection that works for irregular cycles, providing women with clinical-grade data visualization and ovulation prediction.

## Core Features Overview

### 1. Hormone Level Tracking

- **Reproductive Hormones**: Estrogen, Progesterone, LH, FSH
- **Metabolites**: E3G (Estrone-3-glucuronide), PdG (Pregnanediol-3-glucuronide)
- **Additional Markers**: Testosterone, BBT (Basal Body Temperature)
- **Device Integration**: Daily urine tests or continuous monitoring devices

### 2. Smart Ovulation Detection

- **Multi-hormone algorithm**: LH surge + estrogen rise + progesterone confirmation
- **Individual pattern learning**: Adapts to each user's unique ovulation signature
- **Confidence scoring**: Shows prediction reliability based on data quality

### 3. Adaptive Cycle Tracking

- **No fixed length assumption**: Learns individual cycle patterns
- **Phase detection**: Follicular, ovulatory, luteal phase identification
- **Pattern recognition**: Identifies anovulatory cycles and irregularities

### 4. Comprehensive Symptom Logging

- **Physical symptoms**: Period flow, acne level, body hair growth, weight
- **Emotional symptoms**: Depression, mood changes, anxiety levels
- **Custom tracking**: Other notes and personalized symptom categories

### 5. Dual Visualization System

- **Calendar View**: Monthly overview with color-coded hormone levels and symptoms
- **Chart View**: Detailed hormone trend graphs with cycle phase overlays

## User Interface Design

### 1. Main Navigation (4 Tabs)

### **Home Tab: Today's Overview**

```
┌─────────────────────────────────┐
│           Today - Day 14         │
│                                 │
│    🥚 Ovulation predicted in    │
│           2-3 days              │
│                                 │
│  📊 Today's Hormone Levels:     │
│  • LH: 25 mIU/ml (Rising ↗️)    │
│  • Estrogen: High               │
│  • Progesterone: Low            │
│                                 │
│       [Log Test] [Log Symptoms] │
└─────────────────────────────────┘

```

### **Calendar Tab: Monthly View**

```
┌─────────────────────────────────┐
│        March 2025               │
│   S  M  T  W  T  F  S          │
│                  1  2          │
│   3  4  5  6  7  8  9          │
│  10 11 12 13 14 15 16          │
│  17 18 19 20 21 22 23          │
│  24 25 26 27 28 29 30          │
│  31                            │
│                                 │
│ 🔴 Period   🟡 Fertile   🟢 Ovulation │
│ ⚫ Test     💊 Symptoms   📝 Notes    │
└─────────────────────────────────┘

```

### **Charts Tab: Hormone Trends**

```
┌─────────────────────────────────┐
│         Hormone Levels          │
│                                 │
│    [LH] [FSH] [Estrogen] [Prog] │
│                                 │
│  📈 (Interactive line chart     │
│      showing selected hormones  │
│      over time with cycle       │
│      phase backgrounds)         │
│                                 │
│     [1M] [3M] [6M] [All]        │
└─────────────────────────────────┘

```

### **Profile Tab: Settings & Data**

```
┌─────────────────────────────────┐
│           My Profile            │
│                                 │
│  📱 Connected Device: Mira      │
│  📊 Data Export                 │
│  ⚙️  Settings                   │
│  📋 Share with Provider         │
│  🔒 Privacy Settings            │
│  ❓ Help & Support              │
│                                 │
│  📈 Your Stats:                 │
│  • Average cycle: 32 days      │
│  • Ovulation day: ~18          │
│  • Data points: 156            │
└─────────────────────────────────┘

```

---

## Core Functionality Details

### 1. Hormone Data Collection

### **Device Integration Flow**

```
┌─────────────────────────────────┐
│      📱 Connect Your Device      │
│                                 │
│  Supported devices:             │
│  • Mira Hormone Monitor         │
│  • Oova Testing Kit             │
│  • Proov Ovulation Tests        │
│  • Manual entry                │
│                                 │
│         [Connect Device]        │
└─────────────────────────────────┘

```

### **Test Recording Interface**

```
┌─────────────────────────────────┐
│        Record Test Results      │
│                                 │
│  📅 Date: Today, 7:30 AM        │
│  🧪 Test Type: Daily Hormone    │
│                                 │
│  Results:                       │
│  • LH: [25] mIU/ml             │
│  • FSH: [8.2] mIU/ml           │
│  • Estrogen: [145] pg/ml       │
│  • Progesterone: [0.8] ng/ml   │
│                                 │
│      [Save Results]             │
└─────────────────────────────────┘

```

### 2. Smart Ovulation Prediction

### **Multi-Hormone Algorithm**

- **LH Surge Detection**: Identifies 24-48 hour peak before ovulation
- **Estrogen Pattern**: Tracks rise leading to ovulation
- **Progesterone Confirmation**: Confirms ovulation occurred 3-5 days post-peak
- **BBT Integration**: Secondary confirmation via temperature shift

### **Prediction Display**

```
┌─────────────────────────────────┐
│       🥚 Ovulation Forecast      │
│                                 │
│   Predicted: Tomorrow (Day 15)  │
│   Confidence: High (87%)        │
│                                 │
│   Based on:                     │
│   ✅ LH surge detected today    │
│   ✅ Estrogen peaked yesterday  │
│   ⏳ Awaiting progesterone rise │
│                                 │
│     Fertile window: 3 days      │
└─────────────────────────────────┘

```

### 3. Adaptive Cycle Tracking

### **Individual Pattern Learning**

- **Baseline establishment**: First 3 cycles for pattern recognition
- **Cycle length variation**: Tracks shortest/longest/average cycles
- **Phase duration**: Learns individual follicular and luteal phase lengths
- **Anovulation detection**: Identifies cycles without ovulation

### **Cycle Summary View**

```
┌─────────────────────────────────┐
│        Current Cycle            │
│                                 │
│  📅 Cycle Day: 14 of ~32        │
│  📈 Phase: Pre-ovulatory        │
│                                 │
│  Your typical pattern:          │
│  • Ovulation: Day 16-19        │
│  • Cycle length: 30-35 days    │
│  • Luteal phase: 12-14 days    │
│                                 │
│  🎯 Next period: March 28-31    │
└─────────────────────────────────┘

```

### 4. Symptom Logging System

### **Quick Log Interface**

```
┌─────────────────────────────────┐
│        Log Today's Symptoms     │
│                                 │
│  🩸 Period: [None▼]             │
│  😔 Mood: [Good▼]               │
│  🔴 Acne: [Mild▼]               │
│  🪒 Body Hair: [No change▼]     │
│  ⚖️  Weight: [138.2] lbs        │
│                                 │
│  📝 Notes:                      │
│  [Felt energetic today...]     │
│                                 │
│         [Save Symptoms]         │
└─────────────────────────────────┘

```

### **Symptom Categories**

- **Period Tracking**: Flow level (none/light/medium/heavy), color, clots
- **Mood Monitoring**: Depression scale (1-10), anxiety, irritability
- **Physical Symptoms**: Acne severity, body hair growth, weight changes
- **PCOS-Specific**: Insulin resistance symptoms, metabolic markers
- **Custom Categories**: User-defined symptom tracking

### 5. Calendar View Features

### **Color-Coded System**

- **🔴 Red**: Menstrual days (varying intensity for flow level)
- **🟠 Orange**: Fertile window (pre-ovulation)
- **🟢 Green**: Ovulation day (confirmed)
- **🟡 Yellow**: Luteal phase
- **⚫ Black dots**: Test days
- **💊 Pills**: Symptom logging days
- **📝 Notes**: Days with additional notes

### **Interactive Calendar**

- **Tap any day**: View detailed hormone levels and symptoms
- **Multi-month view**: Scroll between months seamlessly
- **Pattern highlighting**: Visual cycle pattern recognition
- **Export functionality**: Share calendar view with providers

### 6. Chart View Capabilities

### **Hormone Trend Visualization**

- **Multi-hormone overlay**: Compare up to 4 hormones simultaneously
- **Cycle phase background**: Visual cycle phase identification
- **Zoom functionality**: Daily, weekly, monthly, and custom date ranges
- **Prediction overlay**: Show predicted vs. actual ovulation timing

### **Chart Interaction Features**

```
┌─────────────────────────────────┐
│    📈 LH & Estrogen - 3 Months  │
│                                 │
│  (Interactive line chart with:) │
│  • Hormone level Y-axis         │
│  • Date X-axis                  │
│  • Cycle phase backgrounds      │
│  • Ovulation markers           │
│  • Symptom correlation dots     │
│                                 │
│   👆 Tap any point for details  │
└─────────────────────────────────┘

```

### **Available Chart Types**

- **Hormone trends**: Individual or combined hormone tracking
- **Cycle overlay**: All hormones with cycle phase highlighting
- **Symptom correlation**: Hormones vs. symptoms over time
- **Prediction accuracy**: Predicted vs. actual ovulation timing

---

## Technical Architecture

### 1. Data Management

### **Core Data Models**

```
HormoneReading {
  date: Date
  lh_level: Float
  fsh_level: Float
  estrogen_level: Float
  progesterone_level: Float
  e3g_level: Float
  pdg_level: Float
  testosterone_level: Float
  bbt: Float
  device_id: String
  confidence_score: Float
}

SymptomLog {
  date: Date
  period_flow: Enum
  mood_score: Integer
  acne_level: Enum
  body_hair: Enum
  weight: Float
  notes: String
  custom_symptoms: Object
}

CycleData {
  cycle_start: Date
  cycle_end: Date
  ovulation_date: Date
  cycle_length: Integer
  luteal_phase_length: Integer
  anovulatory: Boolean
  confidence: Float
}

```

### **Local Storage Strategy**

- **SQLite database**: Local data storage for offline access
- **Encrypted backup**: Secure cloud sync for data recovery
- **Real-time sync**: Immediate device data integration
- **Export formats**: CSV, PDF, clinical summary formats

### 2. Ovulation Detection Algorithm

### **Multi-Factor Analysis**

```
Ovulation Detection Algorithm:
1. LH Surge Identification
   - Detect 2x baseline increase
   - Confirm sustained elevation

2. Estrogen Pattern Analysis
   - Track pre-ovulatory rise
   - Identify peak timing

3. Progesterone Confirmation
   - Monitor post-ovulatory rise
   - Confirm ovulation occurred

4. Pattern Learning
   - Individual baseline establishment
   - Cycle-to-cycle pattern recognition
   - Confidence scoring based on data quality

```

### **Adaptive Learning**

- **Baseline calibration**: First 30-90 days of data collection
- **Pattern recognition**: Individual hormone signature learning
- **Accuracy improvement**: Algorithm refinement with each cycle
- **Anomaly detection**: Identify unusual patterns or anovulatory cycles

### 3. Device Integration

### **Bluetooth Connectivity**

- **Multi-device support**: Compatible with major hormone testing devices
- **Real-time data sync**: Automatic test result import
- **Quality control**: Data validation and error detection
- **Offline capability**: Store data locally when disconnected

### **Supported Devices**

- **Mira Hormone Monitor**: Quantitative LH, FSH, E3G, PdG tracking
- **Oova Testing Kits**: LH and progesterone monitoring
- **Proov Tests**: Progesterone confirmation strips
- **Manual Entry**: Support for lab results and other devices

---

## User Experience Flow

### 1. Onboarding Process

### **Step 1: Profile Setup (3 minutes)**

- Basic health information (age, cycle history, goals)
- PCOS or irregularity screening
- Preferred tracking frequency
- Device connection

### **Step 2: Baseline Learning (First Cycle)**

- Daily testing reminders
- Basic symptom logging introduction
- Pattern recognition explanation
- Progress tracking and encouragement

### **Step 3: Full Feature Access (After 30 days)**

- Predictive capabilities enabled
- Advanced charting features
- Cycle pattern insights
- Export and sharing options

### 2. Daily User Journey

### **Morning Routine**

- Test reminder notification
- Quick device sync
- Automatic hormone level recording
- Today's insights based on current data

### **Evening Check-in**

- Symptom logging prompt
- Daily summary review
- Tomorrow's predictions
- Motivational progress updates

### 3. Monthly Review

### **Cycle Summary**

- Complete cycle analysis
- Ovulation prediction accuracy
- Symptom pattern correlations
- Next cycle predictions

---

## Key Differentiators

### 1. Irregular Cycle Specialization

- **No 28-day assumptions**: Works with any cycle length
- **Individual pattern learning**: Adapts to unique hormonal signatures
- **PCOS-friendly**: Recognizes anovulatory cycles and irregular patterns
- **Confidence scoring**: Transparent prediction reliability

### 2. Comprehensive Hormone Tracking

- **8 hormone markers**: Most complete tracking available
- **Clinical-grade accuracy**: Professional-level data quality
- **Multi-device support**: Works with various testing technologies
- **Integrated symptom correlation**: Links hormones to physical/emotional symptoms

### 3. Advanced Visualization

- **Dual view system**: Calendar and chart views for different needs
- **Interactive charts**: Detailed trend analysis with cycle context
- **Pattern recognition**: Visual cycle phase and hormone pattern identification
- **Provider-ready exports**: Clinical summary reports

---

## Success Metrics

### User Engagement

- **Daily active users**: >75%
- **Test compliance**: >80% test as recommended
- **Feature adoption**: >60% use both calendar and chart views
- **Data completeness**: >70% log symptoms regularly

### Prediction Accuracy

- **Ovulation prediction**: >85% accuracy within 1-day window
- **Cycle length prediction**: <3-day average error
- **User satisfaction**: >4.5/5 stars for prediction reliability

### Clinical Value

- **Provider adoption**: >50% users share data with healthcare providers
- **Treatment correlation**: >70% identify symptom improvements with treatment
- **Cycle understanding**: >80% report better understanding of their patterns

---

## Revenue Model

### Subscription Tiers

- **Basic (Free)**: Limited testing, basic calendar view
- **Premium ($14.99/month)**: Unlimited testing, full charts, export features
- **Clinical ($24.99/month)**: Provider sharing, advanced insights, telehealth integration

### Hardware Partnerships

- **Device discounts**: Bundled hardware pricing
- **Test strip subscriptions**: Monthly delivery programs
- **Clinical partnerships**: Integration with fertility clinics and providers

---

## Development Timeline

### Phase 1: Core Functionality (Months 1-4)

- Basic hormone tracking and storage
- Simple ovulation detection
- Calendar view implementation
- Single device integration

### Phase 2: Advanced Features (Months 4-8)

- Chart view with interactive features
- Adaptive cycle learning
- Multi-device support
- Symptom correlation analysis

### Phase 3: Clinical Integration (Months 8-12)

- Provider dashboard
- Advanced prediction algorithms
- Clinical export features
- Telehealth integration

---

## Conclusion

Luna provides a comprehensive, clinical-grade hormone tracking solution that adapts to individual patterns rather than assuming regularity. By combining detailed hormone monitoring with intelligent cycle detection and dual visualization systems, it serves both women seeking to understand their cycles and healthcare providers needing accurate patient data.

**Key Value Propositions:**

- **Comprehensive tracking**: 8 hormone markers with symptom correlation
- **Adaptive intelligence**: Learns individual patterns, not population averages
- **Clinical integration**: Provider-ready data exports and insights
- **Irregular cycle support**: Works for PCOS and other conditions causing cycle variability

This approach focuses on being the most accurate and comprehensive hormone tracking platform while maintaining simplicity in daily use.