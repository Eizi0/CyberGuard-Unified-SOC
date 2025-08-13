# 🎨 CSU Branding Guidelines

<div align="center">
  <img src="../Logo/CSU Logo.png" alt="CSU Logo" width="300"/>
  
  # CyberGuard Unified SOC
  **Identity & Branding Guidelines**
</div>

---

## 🏢 Brand Identity

### **Mission Statement**
CyberGuard Unified SOC (CSU) est la plateforme de référence pour la sécurité informatique unifiée, combinant innovation technologique et excellence opérationnelle.

### **Brand Values**
- 🛡️ **Sécurité** - Protection maximale des actifs numériques
- 🚀 **Innovation** - Technologies de pointe et solutions avancées
- 🤝 **Fiabilité** - Confiance et disponibilité 24/7
- 🌐 **Unification** - Intégration harmonieuse des outils
- 📊 **Intelligence** - Analyse prédictive et prise de décision éclairée

---

## 🎨 Visual Identity

### **Logo Usage**

#### **Primary Logo**
- **File**: `Logo/CSU Logo.png`
- **Format**: PNG with transparency
- **Usage**: Main branding, documentation, presentations

#### **Application Logo**
- **File**: `frontend/src/assets/csu-logo.png`
- **Format**: Optimized PNG for web
- **Usage**: User interface, web application

### **Logo Specifications**

| Context | Size | Treatment | Background |
|---------|------|-----------|------------|
| **Navigation Bar** | 40px height | White filter for dark theme | Dark |
| **Sidebar Menu** | 32px height | Original colors | Light |
| **Dashboard Header** | 60px height | Original colors | Light/Dark |
| **Login Page** | 100px height | Original colors | Gradient |
| **Documentation** | 200px width | Original colors | White |
| **Email Signatures** | 150px width | Original colors | White |

### **Logo Variations**

```
Primary Logo
├── CSU Logo.png (Full color)
├── CSU Logo White.png (White version)
├── CSU Logo Black.png (Black version)
└── CSU Logo Mono.png (Monochrome)
```

---

## 🎨 Color Palette

### **Primary Colors**
```css
--csu-primary: #1976d2      /* Deep Blue */
--csu-secondary: #dc004e    /* Accent Red */
--csu-success: #4caf50      /* Security Green */
--csu-warning: #ff9800      /* Alert Orange */
--csu-error: #f44336        /* Critical Red */
```

### **Neutral Colors**
```css
--csu-dark: #121212         /* Background Dark */
--csu-paper: #1e1e1e        /* Card Background */
--csu-text-primary: #ffffff /* Primary Text */
--csu-text-secondary: #b3b3b3 /* Secondary Text */
```

### **Semantic Colors**
```css
--csu-info: #2196f3         /* Information */
--csu-security: #4caf50     /* Security Status */
--csu-threat: #ff5722       /* Threat Level */
--csu-analysis: #9c27b0     /* Analysis */
```

---

## 📝 Typography

### **Font Families**
- **Primary**: Roboto (Google Fonts)
- **Secondary**: "Segoe UI", sans-serif
- **Monospace**: "Roboto Mono", monospace

### **Font Weights**
- **Light**: 300
- **Regular**: 400
- **Medium**: 500
- **Bold**: 700

### **Typography Scale**
```css
h1: 2.5rem (40px)    /* Page Titles */
h2: 2rem (32px)      /* Section Headers */
h3: 1.5rem (24px)    /* Subsections */
h4: 1.25rem (20px)   /* Components */
h5: 1.125rem (18px)  /* Labels */
h6: 1rem (16px)      /* Captions */
body: 0.875rem (14px) /* Body Text */
```

---

## 🖼️ Application Integration

### **React Components**

#### **Logo Component**
```jsx
import csuLogo from '../assets/csu-logo.png';

const CSULogo = ({ size = 'medium', variant = 'default' }) => {
  const sizes = {
    small: '32px',
    medium: '40px',
    large: '60px',
    hero: '100px'
  };
  
  const filters = {
    default: 'none',
    white: 'brightness(0) invert(1)',
    dark: 'brightness(0.8)'
  };
  
  return (
    <img
      src={csuLogo}
      alt="CSU Logo"
      style={{
        height: sizes[size],
        width: 'auto',
        filter: filters[variant]
      }}
    />
  );
};
```

#### **Branded Header**
```jsx
const BrandedHeader = ({ title, subtitle }) => (
  <Box sx={{ display: 'flex', alignItems: 'center', mb: 4 }}>
    <CSULogo size="large" />
    <Box sx={{ ml: 2 }}>
      <Typography variant="h4" component="h1">
        {title}
      </Typography>
      {subtitle && (
        <Typography variant="subtitle1" color="text.secondary">
          {subtitle}
        </Typography>
      )}
    </Box>
  </Box>
);
```

---

## 📱 UI Guidelines

### **Navigation Standards**
- Logo always appears in top-left of navigation
- Consistent sizing across all pages
- White filter applied for dark themes
- Clickable logo returns to dashboard

### **Dashboard Integration**
- Large logo in main header section
- Paired with descriptive subtitle
- Consistent spacing and alignment
- Responsive sizing for mobile

### **Authentication Pages**
- Prominent logo placement (100px)
- Centered above form elements
- Clean background for focus
- Branded footer with copyright

---

## 📄 Documentation Standards

### **README Headers**
```markdown
<div align="center">
  <img src="Logo/CSU Logo.png" alt="CSU Logo" width="200"/>
  
  # CyberGuard Unified SOC
  **Subtitle or Description**
</div>
```

### **Technical Documentation**
- Logo in header section
- Consistent sizing (200px width)
- Professional presentation
- Clear alt text for accessibility

---

## 🔧 Asset Management

### **File Organization**
```
Logo/
├── CSU Logo.png           (Primary logo)
├── variants/
│   ├── CSU Logo White.png
│   ├── CSU Logo Black.png
│   └── CSU Logo Mono.png
└── favicons/
    ├── favicon.ico
    ├── favicon-16x16.png
    ├── favicon-32x32.png
    └── apple-touch-icon.png
```

### **Optimization Guidelines**
- PNG format for transparency
- Optimal compression for web
- Multiple size variants
- Vector source files (SVG) when available

---

## 📐 Usage Guidelines

### **✅ Do's**
- Maintain aspect ratio
- Use appropriate size for context
- Apply consistent spacing
- Use approved color variations
- Keep logo legible

### **❌ Don'ts**
- Distort or stretch logo
- Use low-resolution versions
- Apply unauthorized filters
- Combine with competing brands
- Use in offensive contexts

---

## 🚀 Implementation Checklist

### **Frontend Integration**
- [ ] Logo in navigation bar
- [ ] Logo in sidebar menu
- [ ] Logo in dashboard header
- [ ] Logo in login page
- [ ] Logo in email templates
- [ ] Favicon implementation
- [ ] Loading screen logo
- [ ] Error page branding

### **Documentation**
- [ ] README header logo
- [ ] Architecture diagrams
- [ ] User guide branding
- [ ] API documentation
- [ ] Installation guides
- [ ] Troubleshooting docs

### **Marketing Materials**
- [ ] Presentation templates
- [ ] Business cards
- [ ] Email signatures
- [ ] Social media assets
- [ ] Website integration
- [ ] Print materials

---

## 📞 Brand Guidelines Contact

For questions about brand usage, logo requests, or guideline updates:

- **Brand Manager**: CSU Marketing Team
- **Technical Lead**: Development Team
- **Asset Repository**: `/Logo/` directory
- **Documentation**: This file and related docs

---

<div align="center">
  
  **© 2025 CyberGuard Unified SOC - All Rights Reserved**
  
  *These guidelines ensure consistent and professional brand representation across all CSU platforms and materials.*
  
</div>
