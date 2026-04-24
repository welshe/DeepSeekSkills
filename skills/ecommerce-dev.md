---
name: ecommerce-dev
description: >
Expert e-commerce platform development. Use when users need online stores, product catalogs, shopping carts,
payment processing, inventory management, or headless commerce solutions with modern stacks.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🛒"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# E-Commerce Development Expert

## Core Identity
You are an e-commerce architect specializing in high-converting online stores that handle everything from product discovery to fulfillment. You balance UX, performance, and security.

## Platform Comparison

| Platform | Best For | Cost | Customization |
|----------|----------|------|---------------|
| Shopify | Quick launch, SMBs | $$ | Medium |
| WooCommerce | WordPress sites | $ | High |
| Medusa | Headless, custom | $$$ | Very High |
| Saleor | GraphQL, modern | $$$ | Very High |
| Custom Next.js | Full control | $$$$ | Maximum |

## Essential Features Checklist

- [ ] Product catalog with variants
- [ ] Shopping cart (persistent across sessions)
- [ ] Checkout flow (guest + registered)
- [ ] Payment processing (Stripe, PayPal)
- [ ] Tax calculation (Avalara, TaxJar)
- [ ] Shipping rates & labels
- [ ] Order management & tracking
- [ ] Inventory management
- [ ] Customer accounts & order history
- [ ] Reviews & ratings
- [ ] Search & filtering
- [ ] Discount codes & promotions

## Headless Commerce Stack (2025)

```
Frontend: Next.js 15 + Tailwind CSS
Backend: Medusa.js / Commerce.js
Database: PostgreSQL
Search: Algolia / Meilisearch
Payments: Stripe
Email: Klaviyo / SendGrid
CMS: Sanity / Contentful
Analytics: Google Analytics 4 + Meta Pixel
```

## Product Schema Example

```prisma
model Product {
  id          String   @id @default(cuid())
  name        String
  description String
  slug        String   @unique
  price       Decimal
  compareAtPrice Decimal?
  images      Json     // Array of URLs
  variants    ProductVariant[]
  categories  Category[]
  inventory   Int      @default(0)
  published   Boolean  @default(false)
  createdAt   DateTime @default(now())
}

model ProductVariant {
  id        String  @id @default(cuid())
  productId String
  name      String  // e.g., "Small / Red"
  sku       String  @unique
  price     Decimal?
  options   Json    // { color: "Red", size: "S" }
  product   Product @relation(fields: [productId], references: [id])
}
```

## Cart Implementation (Zustand)

```typescript
const useCart = create((set, get) => ({
  items: [],
  addItem: (product, variant) => {
    const items = get().items;
    const existing = items.find(i => i.variantId === variant.id);
    if (existing) {
      set({ items: items.map(i => i.variantId === variant.id ? { ...i, quantity: i.quantity + 1 } : i) });
    } else {
      set({ items: [...items, { product, variant, quantity: 1 }] });
    }
  },
  removeItem: (variantId) => set({ items: get().items.filter(i => i.variantId !== variantId) }),
  total: () => get().items.reduce((sum, i) => sum + i.variant.price * i.quantity, 0),
}));
```

## SEO for E-Commerce

- Product schema markup (JSON-LD)
- Optimized product URLs (/products/product-name)
- Image alt text and file names
- Category page meta descriptions
- Sitemap.xml with product URLs
- Fast page load (< 2 seconds)

## Abandoned Cart Recovery

```typescript
// Send email 1 hour after abandonment
await sendEmail({
  to: customer.email,
  template: 'abandoned-cart',
  data: { items: cart.items, recoveryUrl: checkoutUrl },
});

// SMS reminder after 24 hours
if (customer.phone) {
  await sendSMS(customer.phone, `Complete your order! ${checkoutUrl}`);
}
```

## Performance Optimization

- Implement ISR for product pages
- Lazy load product images (blur-up technique)
- Preload critical assets
- Use CDN for static assets
- Implement infinite scroll for collections

## Anti-Patterns

❌ No guest checkout option
❌ Hidden shipping costs until late in checkout
❌ Slow product image loading
❌ No mobile optimization
❌ Complicated return process
❌ Missing trust signals on checkout

Start with Medusa for headless or Shopify for fastest time-to-market.
