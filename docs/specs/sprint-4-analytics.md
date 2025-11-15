# Sprint 4: Analytics Dashboard

**Duration:** Weeks 8-9
**Status:** Not Started
**Dependencies:** Sprint 1 (Pet Management), Sprint 2 (Product Integration), Sprint 3 (Feeding Logs)

## Overview

Sprint 4 implements analytics and insights based on feeding log data, helping pet owners identify preferences, track trends, and make informed decisions about pet food purchases.

## Goals

1. Create analytics service to process feeding log data
2. Build pet preference dashboard showing favorite foods
3. Implement product performance analytics
4. Add trend visualization with charts
5. Generate insights and recommendations
6. Display feeding statistics and summaries
7. Enable comparison between products and time periods

## User Stories

### US-4.1: View Pet Preferences Dashboard
**As a** pet owner
**I want** to see an overview of my pet's food preferences
**So that** I can understand what they like and make better food choices

**Acceptance Criteria:**
- Dashboard accessible from pet detail screen
- Dashboard shows:
  - Top 5 favorite foods (highest rated, sorted by frequency)
  - Top 5 least favorite foods
  - Overall rating distribution (pie chart)
  - Recent feeding trend (line chart, last 30 days)
  - Total feeding sessions count
  - Days since last feeding
  - Most fed brands
  - Preferred food types (dry/wet/treats)
- Data refreshes when navigating to dashboard
- Loading state while calculating
- Empty state if insufficient data (<5 logs)
- Tap food item to view product details
- Date range filter (7/30/90 days, all time)

**Priority:** P0 (Critical)

### US-4.2: View Favorite Foods List
**As a** pet owner
**I want** to see a ranked list of my pet's favorite foods
**So that** I know what to buy more of

**Acceptance Criteria:**
- Favorite foods screen accessible from dashboard
- List shows all products fed to pet, sorted by:
  - Default: Combined score (rating × frequency)
  - Average rating
  - Times fed
  - Most recent feeding
- Each item shows:
  - Product name and brand
  - Product thumbnail
  - Average rating (stars/visual)
  - Times fed count
  - Last fed date
  - Quick "Log Again" button
- Filter by:
  - Food type (dry/wet/treats/all)
  - Rating threshold (show only 4-5 stars)
  - Date range
- Search functionality
- Tap item for detailed product analytics
- Empty state if no logs
- Pull-to-refresh

**Priority:** P0 (Critical)

### US-4.3: View Product Analytics
**As a** pet owner
**I want** to see detailed analytics for a specific product
**So that** I can understand how it performs across my pets

**Acceptance Criteria:**
- Product analytics accessible from product detail
- Analytics show:
  - Overall performance score (weighted rating)
  - Rating distribution by pet (grouped bar chart)
  - Feeding timeline (when product was fed over time)
  - Per-pet statistics:
    - Each pet's average rating
    - Times fed to each pet
    - First and last feeding dates
  - Comparison with similar products (if available)
  - Total times fed across all pets
  - Popularity trend (if fed multiple times)
- Insights generated:
  - "Top choice for [Pet Name]"
  - "Not popular with [Pet Name]"
  - "Consistently rated high/low"
  - "Recently introduced" (fed <30 days)
- Empty state if not fed to any pet
- Date range filter

**Priority:** P1 (High)

### US-4.4: View Feeding Trends
**As a** pet owner
**I want** to see feeding trends over time
**So that** I can track changes in preferences and patterns

**Acceptance Criteria:**
- Trends screen accessible from analytics dashboard
- Charts display:
  - Feeding frequency over time (line/bar chart)
  - Average rating over time (line chart with trend line)
  - Food type distribution over time (stacked area chart)
  - Brand diversity over time (variety metric)
- Time range selectors:
  - Last 7 days
  - Last 30 days
  - Last 3 months
  - Last 6 months
  - All time
- Toggle between chart types (line/bar)
- Insights generated:
  - "Feeding frequency increasing/decreasing"
  - "Ratings improving/declining"
  - "More variety in recent months"
  - "Consistent feeding pattern"
- Export chart as image
- Empty state if insufficient data

**Priority:** P1 (High)

### US-4.5: Compare Products
**As a** pet owner
**I want** to compare multiple products side-by-side
**So that** I can make informed purchasing decisions

**Acceptance Criteria:**
- Compare feature accessible from:
  - Product detail (Add to compare)
  - Favorites list (multi-select)
- Compare up to 4 products simultaneously
- Comparison table shows:
  - Product images
  - Names and brands
  - Average ratings (across all pets)
  - Times fed
  - Per-pet ratings
  - Price (if available)
  - Ingredients comparison highlights
  - Nutrition facts comparison
- Visual indicators for best/worst in each category
- Export comparison as PDF
- Clear comparison and start over
- Empty state if <2 products selected

**Priority:** P2 (Medium)

### US-4.6: Generate Insights and Recommendations
**As a** pet owner
**I want** to receive insights about my pet's eating habits
**So that** I can optimize their diet and happiness

**Acceptance Criteria:**
- Insights shown on dashboard and pet detail
- Insights generated:
  - "Try more [food type] - highly rated recently"
  - "[Pet] hasn't been fed in X days"
  - "Running out of favorites - consider restocking [products]"
  - "New food performing well - consider making it a staple"
  - "Variety is low - only X different products in last month"
  - "[Pet] is picky - only X% of foods rated highly"
  - "Great variety - fed Y different products this month"
- Recommendations prioritize:
  - Recent high ratings
  - Consistent performance
  - Similar products to favorites
- Dismiss individual insights
- "Learn more" link to detailed analytics
- Insights refresh daily
- Respect user preferences (can disable certain insight types)

**Priority:** P2 (Medium)

### US-4.7: View Multi-Pet Summary
**As a** pet owner with multiple pets
**I want** to see an overview of all pets' preferences
**So that** I can find foods that work well for everyone

**Acceptance Criteria:**
- Multi-pet dashboard accessible from main analytics screen
- Dashboard shows:
  - Universal favorites (rated highly by all pets)
  - Individual pet summaries (compact cards)
  - Feeding balance chart (feeds per pet over time)
  - Most versatile products (work well for multiple pets)
  - Difficult foods (low ratings across pets)
- Insights:
  - "All pets love [product]"
  - "[Pet] is the pickiest eater"
  - "Great variety across pets"
  - "[Pet] and [Pet] have similar tastes"
- Filter to specific subset of pets
- Compare pets' preferences side-by-side
- Only shown if 2+ pets registered

**Priority:** P2 (Medium)

### US-4.8: Export Analytics Report
**As a** pet owner
**I want** to export analytics as a report
**So that** I can share with vets or keep records

**Acceptance Criteria:**
- Export option in analytics menu
- Report formats: PDF, CSV
- PDF report includes:
  - Cover page with pet photo(s)
  - Executive summary of preferences
  - Favorite foods table
  - Charts (if charts exist)
  - Detailed feeding log table
  - Insights and recommendations
  - Date range and generation timestamp
- CSV export includes:
  - All feeding logs with details
  - Product summary statistics
  - Rating distributions
- Email or share report via system share sheet
- Report generation shows progress indicator
- Success message with preview option

**Priority:** P2 (Medium)

## Technical Specifications

### Data Layer

#### Analytics Service

**File:** `lib/data/services/analytics_service.dart`

```dart
import '../../domain/entities/feeding_log.dart';
import '../../domain/entities/product.dart';

class AnalyticsService {
  /// Calculate overall preference score for a product
  /// Combines rating and frequency with weighting
  double calculatePreferenceScore(List<FeedingLog> logs) {
    if (logs.isEmpty) return 0.0;

    final avgRating = logs.map((l) => l.rating.value).reduce((a, b) => a + b) / logs.length;
    final frequency = logs.length;

    // Weight: 70% rating, 30% frequency (normalized to 0-1)
    final normalizedFrequency = (frequency / 100).clamp(0.0, 1.0);
    return (avgRating / 4.0) * 0.7 + normalizedFrequency * 0.3;
  }

  /// Get rating distribution
  Map<PreferenceRating, int> getRatingDistribution(List<FeedingLog> logs) {
    final distribution = <PreferenceRating, int>{};
    for (final rating in PreferenceRating.values) {
      distribution[rating] = 0;
    }

    for (final log in logs) {
      distribution[log.rating] = (distribution[log.rating] ?? 0) + 1;
    }

    return distribution;
  }

  /// Calculate average rating
  double getAverageRating(List<FeedingLog> logs) {
    if (logs.isEmpty) return 0.0;
    final sum = logs.map((l) => l.rating.value).reduce((a, b) => a + b);
    return sum / logs.length;
  }

  /// Get top N products by preference score
  List<ProductSummary> getTopProducts(
    Map<String, List<FeedingLog>> logsByProduct,
    Map<String, Product> products, {
    int limit = 5,
  }) {
    final summaries = <ProductSummary>[];

    for (final entry in logsByProduct.entries) {
      final barcode = entry.key;
      final logs = entry.value;
      final product = products[barcode];

      if (product != null) {
        summaries.add(ProductSummary(
          product: product,
          averageRating: getAverageRating(logs),
          timesFed: logs.length,
          preferenceScore: calculatePreferenceScore(logs),
          lastFedDate: logs.map((l) => l.feedingDate).reduce((a, b) => a.isAfter(b) ? a : b),
        ));
      }
    }

    summaries.sort((a, b) => b.preferenceScore.compareTo(a.preferenceScore));
    return summaries.take(limit).toList();
  }

  /// Get feeding trend data for charting
  List<TrendDataPoint> getFeedingTrend(
    List<FeedingLog> logs, {
    required DateTime startDate,
    required DateTime endDate,
    required Duration interval,
  }) {
    final dataPoints = <TrendDataPoint>[];
    final buckets = <DateTime, List<FeedingLog>>{};

    // Group logs into time buckets
    var currentDate = startDate;
    while (currentDate.isBefore(endDate)) {
      buckets[currentDate] = [];
      currentDate = currentDate.add(interval);
    }

    for (final log in logs) {
      final bucketDate = _getBucketDate(log.feedingDate, startDate, interval);
      if (bucketDate != null && buckets.containsKey(bucketDate)) {
        buckets[bucketDate]!.add(log);
      }
    }

    // Create trend data points
    for (final entry in buckets.entries) {
      dataPoints.add(TrendDataPoint(
        date: entry.key,
        count: entry.value.length,
        averageRating: entry.value.isNotEmpty ? getAverageRating(entry.value) : 0.0,
      ));
    }

    return dataPoints;
  }

  DateTime? _getBucketDate(DateTime date, DateTime startDate, Duration interval) {
    final difference = date.difference(startDate);
    final bucketIndex = difference.inSeconds ~/ interval.inSeconds;
    return startDate.add(interval * bucketIndex);
  }

  /// Generate insights based on feeding data
  List<Insight> generateInsights(
    List<FeedingLog> logs,
    Map<String, Product> products,
  ) {
    final insights = <Insight>[];

    if (logs.isEmpty) {
      return insights;
    }

    // Last feeding date insight
    final lastFeedingDate = logs.map((l) => l.feedingDate).reduce((a, b) => a.isAfter(b) ? a : b);
    final daysSinceLastFeeding = DateTime.now().difference(lastFeedingDate).inDays;

    if (daysSinceLastFeeding > 3) {
      insights.add(Insight(
        type: InsightType.warning,
        title: 'Not fed recently',
        message: 'Last feeding was $daysSinceLastFeeding days ago',
        actionLabel: 'Log Feeding',
      ));
    }

    // Rating trend insight
    final last30Days = DateTime.now().subtract(const Duration(days: 30));
    final recentLogs = logs.where((l) => l.feedingDate.isAfter(last30Days)).toList();

    if (recentLogs.length >= 5) {
      final recentAvg = getAverageRating(recentLogs);
      final olderLogs = logs.where((l) => l.feedingDate.isBefore(last30Days)).toList();

      if (olderLogs.length >= 5) {
        final olderAvg = getAverageRating(olderLogs);
        final improvement = recentAvg - olderAvg;

        if (improvement > 0.5) {
          insights.add(Insight(
            type: InsightType.positive,
            title: 'Preferences improving',
            message: 'Recent foods are rated higher than before',
            actionLabel: 'View Trends',
          ));
        } else if (improvement < -0.5) {
          insights.add(Insight(
            type: InsightType.warning,
            title: 'Recent dislikes',
            message: 'Recent foods are rated lower than usual',
            actionLabel: 'View Favorites',
          ));
        }
      }
    }

    // Variety insight
    final uniqueProducts = logs.map((l) => l.productBarcode).toSet();
    if (uniqueProducts.length < 3 && logs.length > 10) {
      insights.add(Insight(
        type: InsightType.suggestion,
        title: 'Limited variety',
        message: 'Only ${uniqueProducts.length} different products fed recently',
        actionLabel: 'Explore Products',
      ));
    } else if (uniqueProducts.length > 10) {
      insights.add(Insight(
        type: InsightType.positive,
        title: 'Great variety',
        message: '${uniqueProducts.length} different products tried',
        actionLabel: 'View All',
      ));
    }

    // High-performing new product
    final last7Days = DateTime.now().subtract(const Duration(days: 7));
    final veryRecentLogs = logs.where((l) => l.feedingDate.isAfter(last7Days)).toList();

    for (final productBarcode in veryRecentLogs.map((l) => l.productBarcode).toSet()) {
      final productLogs = veryRecentLogs.where((l) => l.productBarcode == productBarcode).toList();
      final allProductLogs = logs.where((l) => l.productBarcode == productBarcode).toList();

      if (productLogs.length >= 2 && allProductLogs.length == productLogs.length) {
        // New product
        final avgRating = getAverageRating(productLogs);
        if (avgRating >= 3.5) {
          final product = products[productBarcode];
          insights.add(Insight(
            type: InsightType.positive,
            title: 'New favorite discovered',
            message: '${product?.name ?? "New product"} is performing well',
            actionLabel: 'View Product',
            data: {'productBarcode': productBarcode},
          ));
        }
      }
    }

    return insights;
  }
}

class ProductSummary {
  final Product product;
  final double averageRating;
  final int timesFed;
  final double preferenceScore;
  final DateTime lastFedDate;

  ProductSummary({
    required this.product,
    required this.averageRating,
    required this.timesFed,
    required this.preferenceScore,
    required this.lastFedDate,
  });
}

class TrendDataPoint {
  final DateTime date;
  final int count;
  final double averageRating;

  TrendDataPoint({
    required this.date,
    required this.count,
    required this.averageRating,
  });
}

class Insight {
  final InsightType type;
  final String title;
  final String message;
  final String? actionLabel;
  final Map<String, dynamic>? data;

  Insight({
    required this.type,
    required this.title,
    required this.message,
    this.actionLabel,
    this.data,
  });
}

enum InsightType {
  positive,
  warning,
  suggestion,
  info,
}
```

### Presentation Layer

#### Analytics Provider

**File:** `lib/presentation/providers/analytics_provider.dart`

```dart
import 'package:flutter/foundation.dart';
import '../../data/services/analytics_service.dart';
import '../../domain/entities/feeding_log.dart';
import '../../domain/entities/pet.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/feeding_log_repository.dart';
import '../../domain/repositories/product_repository.dart';

class AnalyticsProvider extends ChangeNotifier {
  final FeedingLogRepository _feedingLogRepository;
  final ProductRepository _productRepository;
  final AnalyticsService _analyticsService;

  bool _isLoading = false;
  String? _error;

  List<ProductSummary> _topProducts = [];
  List<ProductSummary> _leastFavoriteProducts = [];
  Map<PreferenceRating, int> _ratingDistribution = {};
  List<TrendDataPoint> _feedingTrend = [];
  List<Insight> _insights = [];

  AnalyticsProvider(
    this._feedingLogRepository,
    this._productRepository,
    this._analyticsService,
  );

  bool get isLoading => _isLoading;
  String? get error => _error;
  List<ProductSummary> get topProducts => _topProducts;
  List<ProductSummary> get leastFavoriteProducts => _leastFavoriteProducts;
  Map<PreferenceRating, int> get ratingDistribution => _ratingDistribution;
  List<TrendDataPoint> get feedingTrend => _feedingTrend;
  List<Insight> get insights => _insights;

  Future<void> loadAnalyticsForPet(
    String petId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Load feeding logs
      final logs = await _feedingLogRepository.getLogsByPetId(
        petId,
        startDate: startDate,
        endDate: endDate,
      );

      if (logs.isEmpty) {
        _resetAnalytics();
        return;
      }

      // Load products
      final productBarcodes = logs.map((l) => l.productBarcode).toSet();
      final products = <String, Product>{};

      for (final barcode in productBarcodes) {
        final product = await _productRepository.getProductByBarcode(barcode);
        products[barcode] = product;
      }

      // Group logs by product
      final logsByProduct = <String, List<FeedingLog>>{};
      for (final log in logs) {
        logsByProduct.putIfAbsent(log.productBarcode, () => []).add(log);
      }

      // Calculate analytics
      _topProducts = _analyticsService.getTopProducts(
        logsByProduct,
        products,
        limit: 5,
      );

      _leastFavoriteProducts = _analyticsService.getTopProducts(
        logsByProduct,
        products,
        limit: 5,
      )..sort((a, b) => a.preferenceScore.compareTo(b.preferenceScore));

      _ratingDistribution = _analyticsService.getRatingDistribution(logs);

      // Calculate trend
      final effectiveStartDate = startDate ??
          logs.map((l) => l.feedingDate).reduce((a, b) => a.isBefore(b) ? a : b);
      final effectiveEndDate = endDate ?? DateTime.now();

      _feedingTrend = _analyticsService.getFeedingTrend(
        logs,
        startDate: effectiveStartDate,
        endDate: effectiveEndDate,
        interval: const Duration(days: 1),
      );

      _insights = _analyticsService.generateInsights(logs, products);
    } catch (e) {
      _error = 'Failed to load analytics: $e';
      _resetAnalytics();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _resetAnalytics() {
    _topProducts = [];
    _leastFavoriteProducts = [];
    _ratingDistribution = {};
    _feedingTrend = [];
    _insights = [];
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
```

#### Pet Analytics Dashboard Screen

**File:** `lib/presentation/screens/analytics/pet_analytics_dashboard_screen.dart`

**Key Components:**
- Summary cards (total feeds, days since last, average rating)
- Top favorites list (horizontal scroll)
- Rating distribution pie chart
- Feeding trend line chart
- Insights list
- Date range filter
- Refresh button

**Charting Library:**
- `fl_chart: ^0.64.0` or `charts_flutter: ^0.12.0`

#### Favorite Foods Screen

**File:** `lib/presentation/screens/analytics/favorite_foods_screen.dart`

**Key Components:**
- Product list with rankings
- Sort selector
- Filter options
- Search bar
- Quick "Log Again" buttons
- Empty state

#### Product Analytics Screen

**File:** `lib/presentation/screens/analytics/product_analytics_screen.dart`

**Key Components:**
- Performance score card
- Per-pet rating breakdown
- Feeding timeline chart
- Statistics table
- Insights specific to product
- Compare button

#### Trends Screen

**File:** `lib/presentation/screens/analytics/trends_screen.dart`

**Key Components:**
- Multiple chart types
- Time range selector
- Chart type toggle
- Export button
- Trend indicators (up/down arrows)

## Testing Requirements

### Unit Tests

**File:** `test/unit/analytics_service_test.dart`
- Test preference score calculation
- Test rating distribution
- Test trend calculation with various intervals
- Test insight generation logic
- Test edge cases (empty logs, single log)

**File:** `test/unit/analytics_provider_test.dart`
- Test data loading
- Test analytics computation
- Test error handling
- Mock repositories and service

### Widget Tests

**File:** `test/widget/pet_analytics_dashboard_test.dart`
- Test dashboard rendering with data
- Test empty state
- Test loading state
- Test chart rendering

**File:** `test/widget/favorite_foods_screen_test.dart`
- Test list rendering
- Test sorting
- Test filtering

### Integration Tests

**File:** `test/integration/analytics_flow_test.dart`
- Test complete analytics flow
- Test navigation between analytics screens
- Test data refresh
- Test export functionality

## Definition of Done

- [ ] Analytics service implemented with all calculations
- [ ] Analytics provider with state management
- [ ] Pet analytics dashboard functional with charts
- [ ] Favorite foods screen with sorting/filtering
- [ ] Product analytics screen complete
- [ ] Trends screen with time series charts
- [ ] Insights generation working
- [ ] Multi-pet summary (if multiple pets)
- [ ] Export functionality implemented
- [ ] All unit tests passing with >80% coverage
- [ ] All widget tests passing
- [ ] Integration tests passing
- [ ] Charts rendering correctly on different screen sizes
- [ ] Code reviewed and merged to develop

## Dependencies and Blockers

**Dependencies:**
- Sprint 1, 2, 3 complete
- Sufficient feeding log data for meaningful analytics
- Charting library configured

**Potential Blockers:**
- Chart performance with large datasets
- Complex calculation performance
- PDF generation complexity

## Notes

- Consider caching analytics calculations for performance
- Charts should be responsive and work on small screens
- Analytics should handle edge cases gracefully (single log, etc.)
- Future: Add ML-based recommendations
- Future: Add predictive analytics (when to restock)
- Consider adding goals/achievements (try 10 different foods, etc.)

## Resources

- [FL Chart Package](https://pub.dev/packages/fl_chart)
- [PDF Generation Flutter](https://pub.dev/packages/pdf)
- [CSV Export Flutter](https://pub.dev/packages/csv)
- [Data Visualization Best Practices](https://www.tableau.com/learn/articles/data-visualization)
