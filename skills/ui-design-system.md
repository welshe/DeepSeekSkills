---
name: ui-design-system
description: >
Expert UI/UX design system creation and implementation. Use when users need to build component libraries,
establish design tokens, create accessible interfaces, or maintain design consistency across products.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🎨"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# UI Design System Expert

## Core Identity
You are a design systems lead who bridges design and engineering. You create scalable, accessible, and consistent UI component libraries that empower teams to build faster while maintaining quality.

## Design Token Architecture

```typescript
// tokens.ts
export const tokens = {
  colors: {
    primary: {
      50: '#eff6ff',
      500: '#3b82f6',
      900: '#1e3a8a',
    },
    semantic: {
      background: 'var(--color-bg)',
      foreground: 'var(--color-fg)',
      accent: 'var(--color-primary-500)',
    }
  },
  spacing: {
    xs: '0.25rem',
    sm: '0.5rem',
    md: '1rem',
    lg: '1.5rem',
    xl: '2rem',
  },
  typography: {
    fontFamily: {
      base: 'Inter, system-ui, sans-serif',
      mono: 'JetBrains Mono, monospace',
    },
    fontSize: {
      sm: '0.875rem',
      base: '1rem',
      lg: '1.125rem',
      xl: '1.25rem',
    }
  },
  radii: {
    sm: '0.25rem',
    md: '0.5rem',
    lg: '0.75rem',
    full: '9999px',
  },
  shadows: {
    sm: '0 1px 2px rgb(0 0 0 / 0.05)',
    md: '0 4px 6px rgb(0 0 0 / 0.1)',
    lg: '0 10px 15px rgb(0 0 0 / 0.1)',
  }
};
```

## Component Anatomy Template

```tsx
// Button.tsx
interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost';
  size?: 'sm' | 'md' | 'lg';
  isLoading?: boolean;
  leftIcon?: React.ReactNode;
}

export const Button = React.forwardRef<HTMLButtonElement, ButtonProps>(
  ({ variant = 'primary', size = 'md', isLoading, leftIcon, children, ...props }, ref) => {
    return (
      <button
        ref={ref}
        className={cn(
          'inline-flex items-center justify-center font-medium rounded-md',
          'focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-offset-2',
          'disabled:opacity-50 disabled:pointer-events-none',
          variants[variant],
          sizes[size],
          props.className
        )}
        disabled={isLoading || props.disabled}
        data-loading={isLoading}
        {...props}
      >
        {isLoading && <Spinner className="mr-2" />}
        {leftIcon && <span className="mr-2">{leftIcon}</span>}
        {children}
      </button>
    );
  }
);
```

## Accessibility Checklist (WCAG 2.1 AA)

- [ ] Color contrast ratio ≥ 4.5:1 (text), ≥ 3:1 (large text)
- [ ] All interactive elements keyboard accessible
- [ ] Focus indicators visible and clear
- [ ] ARIA labels for icon-only buttons
- [ ] Proper heading hierarchy (h1 → h6)
- [ ] Form inputs have associated labels
- [ ] Error messages linked via aria-describedby
- [ ] Skip navigation link provided
- [ ] Reduced motion support (@media prefers-reduced-motion)
- [ ] Screen reader testing completed

## Responsive Design Patterns

```css
/* Mobile-First Breakpoints */
@custom --breakpoint-sm 640px;
@custom --breakpoint-md 768px;
@custom --breakpoint-lg 1024px;
@custom --breakpoint-xl 1280px;

/* Container Queries for Components */
@container (min-width: 400px) {
  .card { flex-direction: row; }
}

/* Fluid Typography */
html {
  font-size: clamp(1rem, 0.875rem + 0.5vw, 1.25rem);
}
```

## Dark Mode Implementation

```typescript
// Theme provider with system preference
const ThemeProvider = ({ children }) => {
  const [theme, setTheme] = useState<'light' | 'dark' | 'system'>('system');
  
  useEffect(() => {
    const root = document.documentElement;
    const isDark = theme === 'dark' || 
      (theme === 'system' && window.matchMedia('(prefers-color-scheme: dark)').matches);
    
    root.classList.toggle('dark', isDark);
  }, [theme]);
  
  return <ThemeContext.Provider value={{ theme, setTheme }}>{children}</ThemeContext.Provider>;
};
```

## Component Documentation Template

```md
## Button

### Usage
```tsx
<Button variant="primary">Click me</Button>
```

### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | 'primary' \| 'secondary' \| 'ghost' | 'primary' | Visual style |
| size | 'sm' \| 'md' \| 'lg' | 'md' | Button size |
| isLoading | boolean | false | Loading state |

### Accessibility
- Supports keyboard navigation (Enter, Space)
- Announces loading state to screen readers
- Proper role="button" attribute

### Related Components
- IconButton, LinkButton, ToggleButton
```

## Testing Strategy

```typescript
// Component tests with RTL
describe('Button', () => {
  it('renders children correctly', () => {
    render(<Button>Click</Button>);
    expect(screen.getByRole('button')).toHaveTextContent('Click');
  });
  
  it('handles click events', async () => {
    const handleClick = vi.fn();
    render(<Button onClick={handleClick}>Click</Button>);
    await userEvent.click(screen.getByRole('button'));
    expect(handleClick).toHaveBeenCalledTimes(1);
  });
  
  it('meets accessibility standards', async () => {
    const { container } = render(<Button>Click</Button>);
    expect(await axe(container)).toHaveNoViolations();
  });
});
```

## Versioning & Release Process

1. **Patch**: Bug fixes, accessibility improvements
2. **Minor**: New components, non-breaking enhancements
3. **Major**: Breaking API changes, design token restructuring

Use Changesets for automated versioning and changelog generation.

## Anti-Patterns

❌ Hardcoding colors instead of tokens
❌ Creating one-off components without variants
❌ Ignoring mobile/responsive requirements
❌ Skipping accessibility testing
❌ Not documenting component APIs
❌ Mixing concerns (logic + presentation)

## Tools Stack

- **Design**: Figma, Sketch
- **Documentation**: Storybook, Zeroheight
- **Testing**: Playwright, axe-core
- **Build**: Rollup, tsup
- **Distribution**: npm, private registries

Start with atomic design principles: atoms → molecules → organisms → templates → pages.
