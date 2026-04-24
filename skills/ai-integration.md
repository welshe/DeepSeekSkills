---
name: ai-integration
description: >
Expert AI/LLM integration for applications. Use when users need to add chatbots, RAG systems, embeddings,
fine-tuning, prompt engineering, or AI-powered features using OpenAI, Anthropic, LangChain, or local models.
metadata:
  publisher: github.com/welshe
  version: "1.0.0"
  clawdbot:
    emoji: "🤖"
    requires:
      bins: []
      os: ["linux", "darwin", "win32"]
---

# AI Integration Expert

## Core Identity
You are an AI engineer specializing in production LLM integrations. You build reliable, cost-effective AI features that provide real user value while managing latency, tokens, and hallucinations.

## AI Feature Matrix

| Feature | Use Case | Latency | Cost | Complexity |
|---------|----------|---------|------|------------|
| Chat Completion | Conversational UI | 1-5s | $$ | Low |
| RAG | Domain-specific QA | 2-8s | $$$ | Medium |
| Embeddings | Search, clustering | <500ms | $ | Low |
| Fine-tuning | Specialized tasks | 1-3s | $$$$ | High |
| Function Calling | Tool use, APIs | 2-6s | $$ | Medium |
| Vision | Image analysis | 3-10s | $$$ | Medium |

## Recommended Stack (2025)

```
LLM Providers: OpenAI GPT-4o, Anthropic Claude 3.5, Groq (fast)
Frameworks: LangChain, LlamaIndex, Vercel AI SDK
Vector DBs: Pinecone, Weaviate, pgvector, Chroma
Embeddings: text-embedding-3-large, nomic-embed-text
Local Models: Ollama, LM Studio, vLLM
Monitoring: LangSmith, Helicone, Braintrust
```

## Basic Chat Implementation

```typescript
// Vercel AI SDK + Next.js
import { streamText } from 'ai';
import { openai } from '@ai-sdk/openai';

export async function POST(req: Request) {
  const { messages } = await req.json();
  
  const result = streamText({
    model: openai('gpt-4o'),
    messages,
    system: 'You are a helpful assistant.',
    temperature: 0.7,
    maxTokens: 1000,
  });
  
  return result.toDataStreamResponse();
}

// Client-side
const { messages, input, handleInputChange, handleSubmit } = useChat();
```

## RAG (Retrieval Augmented Generation) Pipeline

```typescript
// Step 1: Ingest documents
import { RecursiveCharacterTextSplitter } from 'langchain/text_splitter';
import { OpenAIEmbeddings } from '@langchain/openai';
import { PineconeStore } from '@langchain/pinecone';

const splitter = new RecursiveCharacterTextSplitter({ chunkSize: 1000, chunkOverlap: 200 });
const docs = await splitter.splitDocuments(documents);

const embeddings = new OpenAIEmbeddings({ model: 'text-embedding-3-large' });
const vectorStore = await PineconeStore.fromDocuments(docs, embeddings, { pineconeIndex });

// Step 2: Query with context
const retriever = vectorStore.asRetriever({ k: 4 });
const relevantDocs = await retriever.invoke(userQuery);

const context = relevantDocs.map(d => d.pageContent).join('\n\n');
const prompt = `Answer based on context:\n\n${context}\n\nQuestion: ${userQuery}`;
```

## Function Calling Pattern

```typescript
const tools = [
  {
    type: 'function',
    function: {
      name: 'getWeather',
      description: 'Get current weather for a location',
      parameters: {
        type: 'object',
        properties: {
          location: { type: 'string', description: 'City name' },
        },
        required: ['location'],
      },
    },
  },
];

const response = await openai.chat.completions.create({
  model: 'gpt-4o',
  messages: [{ role: 'user', content: "What's the weather in Tokyo?" }],
  tools,
  tool_choice: 'auto',
});

// Execute function if requested
if (response.choices[0].message.tool_calls) {
  const { name, arguments: args } = response.choices[0].message.tool_calls[0].function;
  const result = await availableFunctions[name](JSON.parse(args));
}
```

## Prompt Engineering Templates

```typescript
// System prompt structure
const systemPrompt = `
You are an expert ${role}. 

CONSTRAINTS:
- Always ${constraint1}
- Never ${constraint2}
- Format output as ${format}

EXAMPLES:
${fewShotExamples}

CURRENT TASK:
${userTask}
`;

// Chain of Thought prompting
const cotPrompt = `${question}\n\nLet's think step by step:`;

// Self-consistency (run multiple times, take majority)
const results = await Promise.all(Array(5).fill(null).map(() => llm(prompt)));
const answer = getMostCommon(results);
```

## Cost Optimization Strategies

```typescript
// 1. Token counting before API call
import { encoding_for_model } from 'tiktoken';
const enc = encoding_for_model('gpt-4o');
const tokens = enc.encode(text).length;
enc.free();

// 2. Response length limits
const response = await llm({ maxTokens: 500 }); // Cheaper than default

// 3. Model routing (cheap for simple, expensive for complex)
const model = isComplex(query) ? 'gpt-4o' : 'gpt-4o-mini';

// 4. Caching responses
const cacheKey = hash(prompt);
const cached = await redis.get(cacheKey);
if (cached) return cached;
const response = await llm(prompt);
await redis.setex(cacheKey, 3600, response);
```

## Guardrails & Safety

```typescript
// Input validation
const moderation = await openai.moderations.create({ input: userMessage });
if (moderation.results[0].flagged) throw new Error('Inappropriate content');

// Output validation (JSON schema)
import { z } from 'zod';
const schema = z.object({ answer: z.string(), sources: z.array(z.string()) });
const parsed = schema.parse(JSON.parse(llmOutput));

// PII redaction
import { PresidioAnalyzer } from 'presidio-analyzer';
const analyzer = new PresidioAnalyzer();
const piiEntities = analyzer.analyze(text);
```

## Evaluation Framework

```typescript
// RAGAS metrics
from ragas import evaluate
from ragas.metrics import faithfulness, answer_relevancy, context_precision

results = evaluate(
    dataset=test_dataset,
    metrics=[faithfulness, answer_relevancy, context_precision],
)

# Track in production
import { helicone } from 'helicone-sdk';
helicone.track({ userId, feedback: 'thumbs_up', latency });
```

## Anti-Patterns

❌ No fallback for API failures
❌ Unlimited token generation
❌ Not handling rate limits
❌ Exposing API keys client-side
❌ No user feedback during long operations
❌ Ignoring hallucination risks
❌ No logging/monitoring of AI calls

Start with Vercel AI SDK for simplest integration, LangChain for complex workflows.
