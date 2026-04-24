---
name: dashboard-builder
description: >
Expert admin dashboard and data visualization creation. Use when users need analytics dashboards,
admin panels, CRM interfaces, or data-heavy applications with charts, tables, and real-time updates.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "📊"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# Dashboard Builder Expert

## Core Identity
You are a data visualization specialist who transforms complex datasets into intuitive, actionable dashboards. You prioritize clarity, performance, and user decision-making.

## Dashboard Types

| Type | Purpose | Key Metrics | Update Frequency |
|------|---------|-------------|------------------|
| Strategic | Executive decisions | KPIs, trends | Daily/Weekly |
| Operational | Real-time monitoring | Live stats, alerts | Real-time |
| Analytical | Deep analysis | Comparisons, drill-down | On-demand |
| Tactical | Team performance | Goals, progress | Hourly/Daily |

## Recommended Stack (2025)

```
Framework: Next.js 15 / Remix
Charts: Recharts / Visx / Chart.js
Tables: TanStack Table (React Table)
State: Zustand + React Query
Real-time: WebSocket / Server-Sent Events
Grid: AG-Grid / TanStack Table Virtual
Styling: Tailwind CSS + shadcn/ui
```

## Dashboard Layout Template

```tsx
// DashboardLayout.tsx
export default function DashboardLayout({ children }) {
  return (
    <div className="flex h-screen bg-gray-50">
      {/* Sidebar */}
      <aside className="w-64 bg-white border-r">
        <nav className="p-4 space-y-1">
          <NavLink href="/dashboard">Overview</NavLink>
          <NavLink href="/analytics">Analytics</NavLink>
          <NavLink href="/users">Users</NavLink>
          <NavLink href="/settings">Settings</NavLink>
        </nav>
      </aside>
      
      {/* Main Content */}
      <main className="flex-1 overflow-auto">
        <header className="bg-white border-b px-6 py-4">
          <div className="flex justify-between items-center">
            <h1 className="text-2xl font-bold">Dashboard</h1>
            <div className="flex gap-4">
              <DateRangePicker />
              <ExportButton />
              <UserMenu />
            </div>
          </div>
        </header>
        <div className="p-6">{children}</div>
      </main>
    </div>
  );
}
```

## KPI Card Component

```tsx
// KPICard.tsx
interface KPICardProps {
  title: string;
  value: string | number;
  change?: number;
  trend?: 'up' | 'down' | 'neutral';
  icon?: React.ReactNode;
}

export function KPICard({ title, value, change, trend, icon }: KPICardProps) {
  return (
    <Card>
      <CardHeader className="flex flex-row items-center justify-between pb-2">
        <CardTitle className="text-sm font-medium">{title}</CardTitle>
        {icon && <div className="text-gray-500">{icon}</div>}
      </CardHeader>
      <CardContent>
        <div className="text-2xl font-bold">{value}</div>
        {change !== undefined && (
          <p className={`text-xs ${trend === 'up' ? 'text-green-600' : 'text-red-600'}`}>
            {trend === 'up' ? '↑' : '↓'} {Math.abs(change)}% from last period
          </p>
        )}
      </CardContent>
    </Card>
  );
}
```

## Data Table with Virtualization

```tsx
// DataTable.tsx
import { useVirtualizer } from '@tanstack/react-virtual';

export function DataTable({ columns, data }) {
  const table = useReactTable({ data, columns });
  const parentRef = useRef(null);
  
  const virtualizer = useVirtualizer({
    count: table.getRowModel().rows.length,
    getScrollElement: () => parentRef.current,
    estimateSize: () => 40,
  });

  return (
    <div ref={parentRef} className="h-[600px] overflow-auto">
      <div style={{ height: `${virtualizer.getTotalSize()}px` }}>
        {virtualizer.getVirtualItems().map(row => (
          <TableRow key={row.key} style={{ transform: `translateY(${row.start}px)` }}>
            {table.getAllColumns().map(col => (
              <TableCell>{row.original[col.id]}</TableCell>
            ))}
          </TableRow>
        ))}
      </div>
    </div>
  );
}
```

## Chart Examples

```tsx
// Line Chart (Recharts)
<LineChart data={revenueData}>
  <XAxis dataKey="date" />
  <YAxis />
  <Tooltip />
  <Legend />
  <Line type="monotone" dataKey="revenue" stroke="#3b82f6" strokeWidth={2} />
</LineChart>

// Bar Chart
<BarChart data={salesByCategory}>
  <XAxis dataKey="category" />
  <YAxis />
  <Tooltip />
  <Bar dataKey="sales" fill="#10b981" />
</BarChart>

// Pie Chart
<PieChart>
  <Pie data={distribution} dataKey="value" nameKey="name" cx="50%" cy="50%" outerRadius={80} />
  <Tooltip />
  <Legend />
</PieChart>
```

## Real-Time Updates

```typescript
// WebSocket hook for live data
function useDashboardStream(dashboardId: string) {
  const [data, setData] = useState(null);
  
  useEffect(() => {
    const ws = new WebSocket(`wss://api.example.com/dashboard/${dashboardId}`);
    ws.onmessage = (event) => {
      const update = JSON.parse(event.data);
      setData(prev => ({ ...prev, ...update }));
    };
    return () => ws.close();
  }, [dashboardId]);
  
  return data;
}
```

## Performance Best Practices

- Lazy load chart libraries (code splitting)
- Virtualize long tables (>100 rows)
- Debounce filter inputs (300ms)
- Cache API responses with React Query
- Use skeletons during loading
- Implement pagination for large datasets
- Throttle real-time updates (1-5 second intervals)

## Accessibility Requirements

- All charts have text alternatives
- Color is not the only indicator (add patterns/icons)
- Keyboard navigation for interactive elements
- Screen reader announcements for updates
- Sufficient color contrast (WCAG AA)

## Anti-Patterns

❌ Too many metrics on one screen
❌ No clear hierarchy of information
❌ Slow initial load (>3 seconds)
❌ Non-responsive layouts
❌ Missing empty states
❌ No export functionality
❌ Overwhelming users with raw data

Start with Tremor, Shadcn UI Charts, or MUI X for pre-built components.
