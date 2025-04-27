import 'package:flutter_clean_app/data/models/feature_model.dart';
// Removed import for FeatureEntity as it's implicitly included via FeatureModel inheritance
// Removed enums like Priority and FeatureStatus as they are not defined.

/// Generates a list of mock [FeatureModel] instances for development and testing.
List<FeatureModel> generateMockFeatures() {
  final List<FeatureModel> mockFeatures = [
    FeatureModel(
      id: 'mock_feature_1',
      name: 'User Authentication Flow',
      description:
          'Implement the complete user sign-up, sign-in, and password reset functionality using Firebase Auth.',
      labels: ['auth', 'core', 'backend'],
      // Removed fields: priority, createdAt, updatedAt, status, assignee, estimatedHours, actualHours
    ),
    FeatureModel(
      id: 'mock_feature_2',
      name: 'Feature List Filtering',
      description:
          'Allow users to filter the feature list by labels and priority. Implement UI components for filter selection.',
      labels: ['ui', 'filtering', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_3',
      name: 'Offline Data Sync',
      description:
          'Implement local caching and background synchronization for features, allowing offline access.',
      labels: ['data', 'offline', 'sync', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_4',
      name: 'Add Feature Form Validation',
      description:
          'Enhance the "Add Feature" form with comprehensive input validation for all fields.',
      labels: ['ui', 'form', 'validation', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_5',
      name: 'Real-time Updates',
      description:
          'Use streams or WebSockets to provide real-time updates to the feature list when changes occur.',
      labels: ['realtime', 'backend', 'data'],
    ),
    FeatureModel(
      id: 'mock_feature_6',
      name: 'User Profile Screen',
      description:
          'Create a screen where users can view and edit their profile information.',
      labels: ['ui', 'profile', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_7',
      name: 'Analytics Integration',
      description:
          'Integrate Firebase Analytics to track feature usage and user engagement.',
      labels: ['analytics', 'integration', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_8',
      name: 'Push Notifications',
      description:
          'Implement push notifications for important events like feature assignment or status changes.',
      labels: ['notifications', 'backend', 'mobile'],
    ),
    FeatureModel(
      id: 'mock_feature_9',
      name: 'UI Theming (Light/Dark Mode)',
      description:
          'Add support for both light and dark themes throughout the application.',
      labels: ['ui', 'theme', 'frontend', 'design'],
    ),
    FeatureModel(
      id: 'mock_feature_10',
      name: 'Search Functionality',
      description:
          'Implement a search bar to quickly find features by name or description content.',
      labels: ['ui', 'search', 'frontend'],
    ),
    // --- Batch 2 ---
    FeatureModel(
      id: 'mock_feature_11',
      name: 'Onboarding Tutorial Screens',
      description:
          'Create a set of introductory screens to guide new users through the app\'s main functionalities.',
      labels: ['ui', 'onboarding', 'frontend', 'ux'],
    ),
    FeatureModel(
      id: 'mock_feature_12',
      name: 'Export Feature Data (CSV)',
      description:
          'Allow users to export their feature list data to a CSV file.',
      labels: ['data', 'export', 'backend', 'utility'],
    ),
    FeatureModel(
      id: 'mock_feature_13',
      name: 'API Rate Limiting',
      description:
          'Implement rate limiting on the backend API to prevent abuse and ensure stability.',
      labels: ['backend', 'security', 'api'],
    ),
    FeatureModel(
      id: 'mock_feature_14',
      name: 'User Role Management',
      description:
          'Introduce different user roles (e.g., Admin, Editor, Viewer) with varying permissions.',
      labels: ['auth', 'backend', 'core', 'permissions'],
    ),
    FeatureModel(
      id: 'mock_feature_15',
      name: 'Interactive Feature Roadmap',
      description:
          'Display features on a timeline or roadmap view, showing planned vs. actual progress.',
      labels: ['ui', 'visualization', 'frontend', 'reporting'],
    ),
    FeatureModel(
      id: 'mock_feature_16',
      name: 'Password Strength Indicator',
      description:
          'Provide visual feedback on password strength during the sign-up or password change process.',
      labels: ['ui', 'auth', 'security', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_17',
      name: 'Automated E2E Testing Setup',
      description:
          'Set up an end-to-end testing framework (e.g., using Flutter Driver or Patrol) for automated UI tests.',
      labels: ['testing', 'devops', 'automation'],
    ),
    FeatureModel(
      id: 'mock_feature_18',
      name: 'In-App Help/Documentation',
      description:
          'Integrate a section for users to access help guides and documentation directly within the app.',
      labels: ['ui', 'help', 'documentation', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_19',
      name: 'Bulk Label Assignment',
      description:
          'Allow users to select multiple features and assign/remove labels in bulk.',
      labels: ['ui', 'labels', 'bulk-action', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_20',
      name: 'Database Schema Migration Tooling',
      description:
          'Implement tooling and processes for handling database schema migrations safely.',
      labels: ['backend', 'database', 'devops', 'data'],
    ),
    // --- Batch 3 ---
    FeatureModel(
      id: 'mock_feature_21',
      name: 'Accessibility Improvements (WCAG)',
      description:
          'Review and update UI components to meet WCAG accessibility standards (e.g., contrast ratios, screen reader support).',
      labels: ['ui', 'accessibility', 'frontend', 'compliance'],
    ),
    FeatureModel(
      id: 'mock_feature_22',
      name: 'Two-Factor Authentication (2FA)',
      description:
          'Add an optional layer of security with Two-Factor Authentication using TOTP apps.',
      labels: ['auth', 'security', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_23',
      name: 'Performance Monitoring Integration',
      description:
          'Integrate a performance monitoring tool (e.g., Firebase Performance Monitoring, Sentry) to track app speed and crashes.',
      labels: ['performance', 'monitoring', 'devops', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_24',
      name: 'Customizable Dashboard Widgets',
      description:
          'Allow users to customize their dashboard by adding, removing, or rearranging widgets.',
      labels: ['ui', 'dashboard', 'customization', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_25',
      name: 'Comment/Discussion Section for Features',
      description:
          'Implement a commenting system on the feature detail screen for team discussions.',
      labels: ['collaboration', 'ui', 'backend', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_26',
      name: 'Advanced Reporting & Analytics',
      description:
          'Develop advanced reports on feature progress, team velocity, and label usage.',
      labels: ['reporting', 'analytics', 'backend', 'data'],
    ),
    FeatureModel(
      id: 'mock_feature_27',
      name: 'App Localization (i18n)',
      description:
          'Set up the infrastructure for internationalization and add initial translations for Spanish and French.',
      labels: ['localization', 'i18n', 'frontend', 'core'],
    ),
    FeatureModel(
      id: 'mock_feature_28',
      name: 'Git Integration (Link Commits)',
      description:
          'Allow linking Git commits or branches to specific features for better traceability.',
      labels: ['integration', 'devops', 'backend', 'version-control'],
    ),
    FeatureModel(
      id: 'mock_feature_29',
      name: 'Web Version of the App',
      description:
          'Build a web-compatible version of the Flutter application using Flutter Web.',
      labels: ['platform', 'web', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_30',
      name: 'GDPR Compliance Review',
      description:
          'Conduct a review and implement necessary changes to ensure GDPR compliance regarding user data.',
      labels: ['compliance', 'legal', 'backend', 'security'],
    ),
    // --- Batch 4 ---
    FeatureModel(
      id: 'mock_feature_31',
      name: 'Drag-and-Drop Reordering',
      description:
          'Allow users to reorder features in the list view using drag-and-drop.',
      labels: ['ui', 'interaction', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_32',
      name: 'GraphQL API Endpoint',
      description:
          'Provide an alternative GraphQL endpoint alongside the existing REST API.',
      labels: ['backend', 'api', 'graphql', 'data'],
    ),
    FeatureModel(
      id: 'mock_feature_33',
      name: 'SAML/SSO Integration',
      description:
          'Support Single Sign-On (SSO) using SAML for enterprise customers.',
      labels: ['auth', 'sso', 'enterprise', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_34',
      name: 'Custom Field Support',
      description:
          'Allow administrators to define custom fields for features (e.g., target release, component).',
      labels: ['customization', 'backend', 'data', 'core'],
    ),
    FeatureModel(
      id: 'mock_feature_35',
      name: 'Public API Documentation (Swagger/OpenAPI)',
      description:
          'Generate and host interactive API documentation using Swagger/OpenAPI.',
      labels: ['api', 'documentation', 'backend', 'devops'],
    ),
    FeatureModel(
      id: 'mock_feature_36',
      name: 'Feature Templates',
      description:
          'Allow users to create new features based on predefined templates.',
      labels: ['ui', 'templates', 'productivity', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_37',
      name: 'Unit Testing Coverage Improvement',
      description:
          'Increase unit test coverage across critical backend services to over 85%.',
      labels: ['testing', 'backend', 'quality'],
    ),
    FeatureModel(
      id: 'mock_feature_38',
      name: 'Desktop Application Build (MacOS, Windows)',
      description:
          'Create distributable builds of the application for MacOS and Windows desktop platforms.',
      labels: ['platform', 'desktop', 'build', 'devops'],
    ),
    FeatureModel(
      id: 'mock_feature_39',
      name: 'User Activity Audit Log',
      description:
          'Implement an audit log to track significant user actions within the application.',
      labels: ['security', 'logging', 'backend', 'compliance'],
    ),
    FeatureModel(
      id: 'mock_feature_40',
      name: 'Integration with Project Management Tools (Jira, Trello)',
      description:
          'Develop integrations to sync features with popular project management tools like Jira or Trello.',
      labels: ['integration', 'api', 'backend', 'productivity'],
    ),
    // --- Batch 5 ---
    FeatureModel(
      id: 'mock_feature_41',
      name: 'Keyboard Shortcuts',
      description:
          'Implement keyboard shortcuts for common actions like saving, adding, and navigating.',
      labels: ['ui', 'accessibility', 'productivity', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_42',
      name: 'Dependency Management Visualization',
      description:
          'Visualize dependencies between features in a graph or list view.',
      labels: ['ui', 'visualization', 'frontend', 'planning'],
    ),
    FeatureModel(
      id: 'mock_feature_43',
      name: 'CI/CD Pipeline Optimization',
      description:
          'Optimize the CI/CD pipeline for faster build and deployment times.',
      labels: ['devops', 'ci-cd', 'performance'],
    ),
    FeatureModel(
      id: 'mock_feature_44',
      name: 'A/B Testing Framework',
      description:
          'Integrate a framework to conduct A/B tests on new UI elements or features.',
      labels: ['analytics', 'testing', 'backend', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_45',
      name: 'Multi-tenant Architecture Refactor',
      description:
          'Refactor the backend to better support multi-tenancy for different organizations.',
      labels: ['backend', 'architecture', 'scalability', 'core'],
    ),
    FeatureModel(
      id: 'mock_feature_46',
      name: 'Voice Command Input',
      description:
          'Explore and implement basic voice commands for adding or searching features.',
      labels: ['accessibility', 'innovation', 'frontend', 'mobile'],
    ),
    FeatureModel(
      id: 'mock_feature_47',
      name: 'Serverless Function Implementation',
      description:
          'Migrate specific background tasks (e.g., report generation) to serverless functions.',
      labels: ['backend', 'serverless', 'architecture', 'performance'],
    ),
    FeatureModel(
      id: 'mock_feature_48',
      name: 'On-Premise Deployment Option',
      description:
          'Develop documentation and scripts to support on-premise deployment for enterprise clients.',
      labels: ['deployment', 'enterprise', 'backend', 'devops'],
    ),
    FeatureModel(
      id: 'mock_feature_49',
      name: 'Gamification Elements',
      description:
          'Introduce gamification elements like points or badges for completing tasks or contributing features.',
      labels: ['ui', 'engagement', 'frontend', 'innovation'],
    ),
    FeatureModel(
      id: 'mock_feature_50',
      name: 'Machine Learning Model for Priority Suggestion',
      description:
          'Train a simple ML model to suggest feature priorities based on historical data.',
      labels: ['ai-ml', 'backend', 'data', 'innovation'],
    ),
    // --- Batch 6 ---
    FeatureModel(
      id: 'mock_feature_51',
      name: 'Chatbot Integration for Support',
      description:
          'Integrate a simple chatbot to answer common user questions.',
      labels: ['support', 'ai-ml', 'integration', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_52',
      name: 'Enhanced Data Encryption at Rest',
      description:
          'Implement stronger encryption methods for sensitive data stored in the database.',
      labels: ['security', 'backend', 'database', 'compliance'],
    ),
    FeatureModel(
      id: 'mock_feature_53',
      name: 'Real-time Collaboration Editing (Experimental)',
      description:
          'Experiment with real-time collaborative editing of feature descriptions using CRDTs or similar.',
      labels: ['collaboration', 'realtime', 'backend', 'innovation'],
    ),
    FeatureModel(
      id: 'mock_feature_54',
      name: 'Public Status Page',
      description:
          'Create a public status page showing system uptime and ongoing incidents.',
      labels: ['devops', 'monitoring', 'communication', 'frontend'],
    ),
    FeatureModel(
      id: 'mock_feature_55',
      name: 'Plugin Architecture for Extensions',
      description:
          'Develop a basic plugin architecture to allow third-party extensions.',
      labels: ['architecture', 'backend', 'core', 'extensibility'],
    ),
    FeatureModel(
      id: 'mock_feature_56',
      name: 'Predictive Analytics for Completion Dates',
      description:
          'Use historical data to predict estimated completion dates for features.',
      labels: ['analytics', 'ai-ml', 'reporting', 'data'],
    ),
    FeatureModel(
      id: 'mock_feature_57',
      name: 'Improved Error Handling and Reporting',
      description:
          'Refine error handling across the application with more user-friendly messages and detailed logging.',
      labels: ['quality', 'frontend', 'backend', 'logging'],
    ),
    FeatureModel(
      id: 'mock_feature_58',
      name: 'Data Archiving Strategy',
      description:
          'Define and implement a strategy for archiving old or inactive feature data.',
      labels: ['data', 'backend', 'database', 'performance'],
    ),
    FeatureModel(
      id: 'mock_feature_59',
      name: 'White-labeling Capabilities',
      description:
          'Allow enterprise customers to white-label the application with their own branding.',
      labels: ['enterprise', 'customization', 'frontend', 'backend'],
    ),
    FeatureModel(
      id: 'mock_feature_60',
      name: 'Blockchain Integration for Audit Trail (Proof-of-Concept)',
      description:
          'Build a PoC for using a private blockchain to create an immutable audit trail.',
      labels: ['blockchain', 'security', 'innovation', 'backend'],
    ),
    // --- End of mock features ---
  ];

  return mockFeatures;
}

// --- Potentially add more utility functions related to mock data below ---
