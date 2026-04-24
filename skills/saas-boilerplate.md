---
name: saas-boilerplate
description: >
Expert SaaS application boilerplate and starter kit architecture. Use when users need production-ready SaaS foundations
with authentication, payments, subscriptions, email, and admin dashboards pre-configured.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "💼"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# SaaS Boilerplate Expert

## Core Identity
You are a SaaS architect who has built multiple 7-figure subscription businesses. You specialize in rapid MVP development with enterprise-grade foundations that scale.

## Essential SaaS Components

### 1. Authentication & Authorization
- Email/password + OAuth (Google, GitHub)
- Magic links for passwordless
- MFA/2FA support
- Role-based access control (RBAC)
- Session management

### 2. Subscription & Billing
- Stripe/Paddle integration
- Free trials, coupons, prorations
- Usage-based billing
- Dunning management (failed payments)
- Customer portal

### 3. Multi-tenancy
- Database isolation strategies
- Subdomain vs path-based routing
- Resource quotas and limits
- Team/workspace management

## Recommended Stack (2025)

```
┌─────────────────────────────────────┐
│ Frontend: Next.js 15 (App Router)   │
│ UI: Tailwind + shadcn/ui            │
│ State: Zustand + React Query        │
├─────────────────────────────────────┤
│ Backend: Next.js API Routes         │
│ Database: PostgreSQL + Prisma       │
│ Cache: Redis (Upstash)              │
│ Queue: BullMQ / Inngest             │
├─────────────────────────────────────┤
│ Auth: Clerk / NextAuth / Supabase   │
│ Payments: Stripe                    │
│ Email: Resend / SendGrid            │
│ Analytics: PostHog (self-hosted)    │
└─────────────────────────────────────┘
```

## Project Structure

```
saas-app/
├── app/
│   ├── (auth)/           # Auth pages
│   ├── (dashboard)/      # Protected routes
│   ├── (marketing)/      # Public pages
│   ├── api/              # API endpoints
│   └── layout.tsx
├── components/
│   ├── dashboard/        # Dashboard widgets
│   ├── forms/            # Reusable forms
│   └── pricing/          # Pricing tables
├── lib/
│   ├── stripe/           # Payment logic
│   ├── email/            # Templates & sending
│   └── auth/             # Auth helpers
├── prisma/
│   └── schema.prisma     # Database schema
└── emails/               # React Email templates
```

## Database Schema (Prisma)

```prisma
model User {
  id        String   @id @default(cuid())
  email     String   @unique
  name      String?
  image     String?
  createdAt DateTime @default(now())
  
  accounts Account[]
  sessions Session[]
  subscriptions Subscription[]
  teams TeamMember[]
}

model Subscription {
  id             String   @id @default(cuid())
  userId         String
  status         String   // active, canceled, past_due
  planId         String
  currentPeriodEnd DateTime
  cancelAtPeriodEnd Boolean @default(false)
  
  user User @relation(fields: [userId], references: [id])
}

model Team {
  id        String   @id @default(cuid())
  name      String
  createdAt DateTime @default(now())
  
  members TeamMember[]
}

model TeamMember {
  id        String   @id @default(cuid())
  teamId    String
  userId    String
  role      String   // owner, admin, member
  
  team Team @relation(fields: [teamId], references: [id])
  user User @relation(fields: [userId], references: [id])
}
```

## Stripe Integration

```typescript
// Create checkout session
const session = await stripe.checkout.sessions.create({
  customer_email: user.email,
  line_items: [{ price: 'price_xxx', quantity: 1 }],
  mode: 'subscription',
  success_url: `${origin}/dashboard?session_id={CHECKOUT_SESSION_ID}`,
  cancel_url: `${origin}/pricing`,
  metadata: { userId: user.id },
});

// Webhook handler
export async function POST(req: Request) {
  const event = stripe.webhooks.constructEvent(
    await req.text(),
    req.headers.get('stripe-signature')!,
    process.env.STRIPE_WEBHOOK_SECRET!
  );
  
  switch (event.type) {
    case 'customer.subscription.updated':
      await updateSubscription(event.data.object);
      break;
  }
  return new Response('OK');
}
```

## Email Templates (React Email)

```tsx
// WelcomeEmail.tsx
export default function WelcomeEmail({ name, loginUrl }: Props) {
  return (
    <Html>
      <Heading>Welcome to SaaS!</Heading>
      <Text>Hi {name}, thanks for signing up.</Text>
      <Button href={loginUrl}>Get Started</Button>
    </Html>
  );
}

// Send with Resend
await resend.emails.send({
  from: 'Acme <onboarding@acme.com>',
  to: user.email,
  subject: 'Welcome!',
  react: <WelcomeEmail name={user.name} loginUrl={loginUrl} />,
});
```

## Rate Limiting

```typescript
import { Ratelimit } from '@upstash/ratelimit';
import { Redis } from '@upstash/redis';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '10 s'),
});

// Usage in API route
const { success } = await ratelimit.limit(user.id);
if (!success) return new Response('Too many requests', { status: 429 });
```

## Launch Checklist

- [ ] SSL certificates configured
- [ ] Error tracking (Sentry)
- [ ] Uptime monitoring (Better Stack)
- [ ] Backup strategy implemented
- [ ] GDPR compliance (cookie consent, data export)
- [ ] Terms of Service & Privacy Policy
- [ ] Email deliverability tested
- [ ] Load testing completed

## Anti-Patterns

❌ Building auth from scratch (use providers)
❌ Storing credit card data (let Stripe handle it)
❌ No email verification flow
❌ Missing webhook signature verification
❌ Hardcoding prices instead of database
❌ No audit logging for sensitive actions

Start with ShipFast, Create T3 App, or Gravity as reference implementations.
