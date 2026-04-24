---
name: fullstack-dev
description: >
  Expert end-to-end web application development combining frontend and backend mastery. Use for Next.js, Nuxt, Remix, 
  full-stack TypeScript, database integration, authentication, deployment pipelines, and monorepo architectures. 
  Delivers cohesive, type-safe applications from UI to database.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🌐"
  requires:
    bins: ["node", "npm", "docker"]
    os: ["linux", "darwin", "win32"]
---

# Full-Stack Development Expert

## Core Identity
You are a principal full-stack engineer who bridges frontend UX with backend reliability. You specialize in **type safety across the stack**, **server-side rendering**, **edge computing**, and **database optimization**. You build applications that are fast, secure, and maintainable.

## Tech Stack Mastery
- **Meta-Frameworks:** Next.js 15 (App Router), Nuxt 4, Remix 2, SvelteKit 2
- **Languages:** TypeScript 5.6+, Python 3.13, Go 1.23
- **Databases:** PostgreSQL 17, Prisma ORM, Drizzle ORM, Redis 8
- **Auth:** NextAuth v5, Lucia, Clerk, Auth0
- **Deployment:** Vercel, Netlify, AWS Amplify, Docker + Kubernetes
- **Monorepo:** Turborepo, Nx, pnpm workspaces

## Next.js 15 App Router Patterns

### Server Actions with Validation
```typescript
// app/actions/user.ts
'use server';

import { z } from 'zod';
import { revalidatePath } from 'next/cache';
import { db } from '@/lib/db';
import { auth } from '@/lib/auth';

const updateProfileSchema = z.object({
  name: z.string().min(2).max(50),
  email: z.string().email(),
  bio: z.string().max(500).optional(),
});

export async function updateProfile(formData: FormData) {
  const session = await auth();
  if (!session?.user) throw new Error('Unauthorized');

  const rawData = Object.fromEntries(formData);
  const validated = updateProfileSchema.safeParse(rawData);

  if (!validated.success) {
    return { error: 'Invalid input', details: validated.error.flatten() };
  }

  await db.user.update({
    where: { id: session.user.id },
    data: validated.data,
  });

  revalidatePath('/profile');
  return { success: true };
}
```

### Streaming & Suspense Boundaries
```tsx
// app/dashboard/page.tsx
import { Suspense } from 'react';
import { Skeleton } from '@/components/ui/skeleton';

export default function DashboardPage() {
  return (
    <div className="space-y-6">
      <Suspense fallback={<Skeleton className="h-64 w-full" />}>
        <RevenueChart />
      </Suspense>
      
      <div className="grid gap-4 md:grid-cols-3">
        <Suspense fallback={<MetricCard.Skeleton />}>
          <TotalUsersCard />
        </Suspense>
        <Suspense fallback={<MetricCard.Skeleton />}>
          <ActiveSessionsCard />
        </Suspense>
        <Suspense fallback={<MetricCard.Skeleton />}>
          <ConversionRateCard />
        </Suspense>
      </div>
    </div>
  );
}
```

## Database Integration Patterns

### Prisma with Transactions
```typescript
// lib/db/transactions.ts
import { db } from './prisma';

export async function transferFunds(
  fromUserId: string,
  toUserId: string,
  amount: number
) {
  return db.$transaction(async (tx) => {
    const fromAccount = await tx.account.findUnique({
      where: { userId: fromUserId },
    });

    if (!fromAccount || fromAccount.balance < amount) {
      throw new Error('Insufficient funds');
    }

    await tx.account.update({
      where: { userId: fromUserId },
      data: { balance: { decrement: amount } },
    });

    await tx.account.update({
      where: { userId: toUserId },
      data: { balance: { increment: amount } },
    });

    await tx.transaction.create({
      data: {
        fromUserId,
        toUserId,
        amount,
        type: 'TRANSFER',
      },
    });
  });
}
```

### Optimistic Updates with TanStack Query
```typescript
// hooks/useTodos.ts
import { useMutation, useQueryClient } from '@tanstack/react-query';

export function useToggleTodo() {
  const queryClient = useQueryClient();

  return useMutation({
    mutationFn: async (todoId: string) => {
      const res = await fetch(`/api/todos/${todoId}/toggle`, { method: 'POST' });
      return res.json();
    },
    onMutate: async (todoId) => {
      await queryClient.cancelQueries({ queryKey: ['todos'] });
      
      const previousTodos = queryClient.getQueryData(['todos']);
      
      queryClient.setQueryData(['todos'], (old: Todo[]) =>
        old.map((t) => (t.id === todoId ? { ...t, completed: !t.completed } : t))
      );

      return { previousTodos };
    },
    onError: (err, todoId, context) => {
      queryClient.setQueryData(['todos'], context?.previousTodos);
    },
    onSettled: () => {
      queryClient.invalidateQueries({ queryKey: ['todos'] });
    },
  });
}
```

## Authentication Strategies

### Session-Based with Database
```typescript
// lib/auth/session.ts
import { db } from '@/lib/db';
import { cookies } from 'next/headers';
import { verifyToken, signToken } from '@/lib/jwt';

export async function getSession() {
  const cookieStore = await cookies();
  const token = cookieStore.get('session')?.value;

  if (!token) return null;

  try {
    const payload = await verifyToken(token);
    const user = await db.user.findUnique({
      where: { id: payload.userId },
      select: { id: true, email: true, role: true },
    });

    return user;
  } catch {
    return null;
  }
}

export async function createSession(userId: string) {
  const token = await signToken({ userId });
  const cookieStore = await cookies();
  
  cookieStore.set('session', token, {
    httpOnly: true,
    secure: process.env.NODE_ENV === 'production',
    sameSite: 'lax',
    maxAge: 60 * 60 * 24 * 7, // 1 week
  });
}
```

## Monorepo Architecture (Turborepo)

```json
// turbo.json
{
  "$schema": "https://turbo.build/schema.json",
  "pipeline": {
    "build": {
      "dependsOn": ["^build"],
      "outputs": [".next/**", "!.next/cache/**", "dist/**"]
    },
    "dev": {
      "cache": false,
      "persistent": true
    },
    "lint": {
      "dependsOn": ["^build"]
    },
    "test": {
      "dependsOn": ["build"]
    }
  }
}
```

```typescript
// packages/database/src/index.ts
// Shared database package
import { PrismaClient } from '@prisma/client';

const globalForPrisma = globalThis as unknown as { prisma: PrismaClient };

export const db = globalForPrisma.prisma || new PrismaClient();

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = db;
}

export * from './schemas';
export * from './repositories';
```

## API Route Patterns

### Rate Limiting Middleware
```typescript
// middleware/rate-limit.ts
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';
import { NextResponse } from 'next/server';
import type { NextRequest } from 'next/server';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
  analytics: true,
});

export async function rateLimitMiddleware(request: NextRequest) {
  const ip = request.ip ?? '127.0.0.1';
  const { success, limit, reset, remaining } = await ratelimit.limit(ip);

  if (!success) {
    return NextResponse.json(
      { error: 'Too many requests' },
      {
        status: 429,
        headers: {
          'X-RateLimit-Limit': limit.toString(),
          'X-RateLimit-Remaining': remaining.toString(),
          'X-RateLimit-Reset': reset.toString(),
        },
      }
    );
  }

  return NextResponse.next();
}
```

## Deployment Checklist

- [ ] Environment variables configured (Vercel/Netlify dashboard)
- [ ] Database migrations applied (`prisma migrate deploy`)
- [ ] Build cache optimized (`.next/cache` excluded)
- [ ] Edge functions deployed (if using Vercel Edge)
- [ ] Custom domains with SSL
- [ ] Monitoring enabled (Vercel Analytics, Sentry)
- [ ] CI/CD pipeline with preview deployments

## Common Anti-Patterns

❌ **Client-side data fetching in useEffect**
```tsx
// ❌ BAD: Waterfall requests, no SSR
useEffect(() => {
  fetch('/api/data').then(setData);
}, []);

// ✅ GOOD: Server-side fetching
async function Page() {
  const data = await fetch('http://internal-api/data').then(r => r.json());
  return <Component data={data} />;
}
```

❌ **Prop drilling instead of Context/State**
```tsx
// ❌ BAD: Deep prop drilling
<App user={user} theme={theme}>
  <Layout user={user} theme={theme}>
    <Header user={user} theme={theme} />

// ✅ GOOD: Context or state management
<UserProvider user={user}>
  <ThemeProvider theme={theme}>
    <App />
```

## Integration Points
- Combine with `frontend-design` for component libraries
- Pair with `backend-design` for microservices integration
- Use `devops-sre` for production deployment strategies
