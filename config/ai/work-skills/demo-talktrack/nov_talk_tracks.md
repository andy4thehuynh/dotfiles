# NOV RAG + Agent Memory Demo — Talk Track Exemplar

Format exemplar. 30-min four-pillar eval, solo presenter.
Tags appear as originally written ([Say]/[TT]/[Action]) — the current
standard is [tt] / [👉] / [🙋‍♀️].

## Slide 1 — Andy Huynh, Solutions Engineer

[Say]: "Thanks everyone for joining. I'm Andy, Solutions Engineer at Couchbase. Today I'm going to show you how Couchbase handles the four capabilities your team flagged for the supplier onboarding chatbot — document ingestion, vector search, semantic caching, and agent memory. 
I'll keep slides light and spend most of our time in live applications with real data. Ask questions throughout "
[Action]: Advance to Slide 2.

Timing: ~45 seconds
Notes: Don't linger here. The title slide is a handshake — acknowledge the room, set expectations on format (slides light, mostly live), and move. If the NOV team does introductions first, let that happen naturally before you start.

## Slide 2 — Agenda

[Say]: "So I’ll confirm the four requirements you shared with us to make sure we're aligned. 
Then we'll go into RAG — I'll show you the architecture and then do a live demo using one of your own NOV PDFs. 
After that, we'll shift to Couchbase Agent Memory — same approach, architecture first, then a live demo of a multi-agent application. And we'll wrap with next steps."
[Action]: Advance to Slide 3.

## Slide 3 — What We Heard From You

[TT]: "Before we go any further, I want to make sure we're aligned on what you asked for. 
You told us you're building a supplier onboarding chatbot and you need four things from the data platform: 
The ability to ingest and chunk documents like compliance policies and vendor forms
vector search powered by GSI so suppliers can ask natural-language questions
semantic caching so repeated questions don't hit the LLM every time,
And agent memory so the chatbot remembers where a supplier left off across sessions. 
The key message on this slide — and what I'll prove to you in the next 30 minutes — is that all four of these can run on one Couchbase cluster. 
No separate vector database, no Redis for caching, no external memory store."
[Action]: Advance to Slide 4.

Timing: ~60 seconds
Notes: Point at each circle as you say its name. Let the bottom line — "one platform" — land. Pause briefly after saying it before advancing. This is the thesis of the entire demo.

## Slide 4 — RAG

TT]: "Let's start with RAG — Retrieval-Augmented Generation. This is the foundation of any AI chatbot that needs to answer questions from your own documents rather than just relying on the LLM's training data."
[Action]: Advance to Slide 5. Don't pause here — this is a visual beat, not a content slide.

Timing: ~10 seconds
Notes: This slide exists to give the audience a visual reset between sections. Say one sentence, advance. If it feels too fast, that's correct — section dividers should be transitions, not destinations.
Ready for Slide 5?

## Slide 5 — Couchbase | Vectorization Service & Agent Memory

[TT]: "This is the Couchbase AI Data Plane — it’s the full picture of our AI capabilities. 
There's a lot here, but today we're zooming into two areas. On the right you see Agent Memory — we'll get to that in the second half. 
And the Data Processing Service on the left — that's what powers the RAG pipeline I'm about to show you. 
Documents come in from the left — PDFs, unstructured data — they get processed, vectorized, and stored in your Couchbase cluster. 
The important takeaway is these aren't separate products.
They're services running on the same data plane, same cluster, your team already knows."
[Action]: Advance to Slide 6.

Timing: ~60 seconds
Notes: Don't try to explain every box. Gesture at the two areas you're covering (Data Processing + Vectorization, and Agent Memory), acknowledge the rest exists, and move on. If someone asks about MCP Server or Agent Catalog, say "happy to go deeper on those in Q&A" and keep moving. This slide earns trust by showing breadth without getting lost in it.

## Slide 6 — 1

[TT]: "Here's what's actually happening under the hood. There are two paths in a RAG application. 
On the left side is the write path — your documents get sent to an embedding model, the model returns vectors, and those vectors plus the original text get stored in Couchbase's Data Service. 
The Indexer picks them up and maintains your vector indexes across partitions and nodes — that's steps 1 through 4. 
On the right side is the read path — a user asks a question, that question gets embedded the same way, and then the app calls Couchbase's Query Service with a vector search request. This is step 7 and 8 — and this is where it feels familiar. 
Step 8 uses Hyperscale or Composite Vector Indexes, which are GSI-backed. That means you're writing SQL++ queries, not a proprietary vector query language. Your developers already know this
The Query Service returns the top-k most similar chunks, those get combined with the original question as a prompt to the LLM, and you get an answer grounded in your documents. 
I'm going to show you this entire flow live — with your own NOV content — right now."
[Action]: Advance to Slide 7.

Timing: ~90 seconds
Notes: This is the densest slide in the deck. Don't walk through all 10 steps individually — hit the two paths (write and read), emphasize step 8 (GSI/SQL++), and land on "let me show you this live." If you see eyes glazing, cut to "this is easier to see than explain — let me show you" and advance. The live demo is the proof; this slide is the map.

## Slide 7 — Live Demo – RAG

Slide 7 — Live Demo – RAG
Section transition slide with "Live Demo – RAG" and Couchbase branding

[TT]: "Let's see it in action."
[Action]: Switch from slides to your browser. Share the screen with the rag-demo Streamlit app (Tab 2).

LIVE DEMO — RAG (15 min)
Part 1: Document Ingestion (~3 min)
[Action]: Show empty pdf-docs.shared.docs collection
[TT]: You’ll see we have an empty collection. This is where the results of our uploaded PDF will live. We’ll come back to this shortly
[TT]: "I'm going to upload a real NOV document — your Top Drive Technologies brochure — so you can see the full ingestion pipeline from raw PDF to queryable vectors in Couchbase."
[Action]: Click the PDF upload widget in the Streamlit sidebar. [Action]: Select the NOV Top Drive Technologies PDF from your desktop.
[TT while uploading]: "Under the hood, LangChain's PDF loader is splitting this into chunks. Each chunk gets sent to OpenAI's embedding model, and the resulting vector plus the original text gets written as a JSON document into Couchbase. Chunk size and overlap are configurable — for dense technical content like spec sheets, you'd want smaller chunks with more overlap so you don't lose context at the boundaries."
[Wait]: ~15-30 seconds for ingestion to complete.
[Fallback if slow]: "Embedding time depends on document size and the OpenAI API. In production you'd batch this — Couchbase handles high-throughput writes natively since it's a memory-first architecture."
[Action]: Once complete, switch to Tab 3: Couchbase Server UI (localhost:8091). [Action]: Navigate to your bucket → scope → document collection. [Action]: Click "Documents" to show the list of ingested chunks.
[TT]: "Here's what landed in Couchbase. Each document is one chunk from the PDF."
[Action]: Click on any document to expand and show the JSON structure.
[TT]: "You can see the structure — the raw text from the chunk, metadata including source and page number, and the embedding vector.
This is a standard JSON document in Couchbase. You can query it with SQL++, index it, replicate it with XDCR, secure it with RBAC — it’s just a JSON document with your embedding vector living together side by side. There's no separate vector store to manage."

✅ So that’s the data ingestion and chunking requirement

Part 2: Vector Search (~5 min)
[Action]: Switch back to the rag-demo Streamlit app (Tab 2).
[TT]: "Now let's query this data. 
I'll ask questions about NOV's top drives, and you’re going to see the RAG answer (with couchbase logo) and the pure LLM answer below that"
[Action]: Type in the chat box:
What is the maximum continuous torque and max speed of the TDS-11HD top drive?
[Wait for response]
[TT]: "The RAG answer pulls the exact spec: 58,800 ft-lb at 228 RPM. 
The pure LLM on the bottom might get this right from training data, might not — and you'd never know if it was current. 
[Action]: open SPACE+9 to highlight max continuous torque of TDS-11HD
[TT]: You’ll see the max continuous torque and max speed values are exactly the same as what the RAG outputted - so it’s retrieving data from sources and grounding its answers in that. 
In regards to the indexes…
[Action]: Switch to Tab 3: Couchbase Server UI (localhost:8091). [Action]: Navigate to Search → click Show Index definition JSON for cached_llm_responses
[TT]: "This is the vector index that made that query work. 
It's a GSI-backed index — same infra your team already uses for standard Couchbase queries. There are two types available in Couchbase 8.0: 
Hyperscale indexes, which are optimized for pure vector search at billions of documents with a low memory footprint, 
and Composite indexes, which combine vector similarity with scalar filters in a single index — so you could search 'find chunks similar to this question WHERE doc_type equals compliance plus more filters… this allows you to narrow down the search space before the vector comparison, which means it's both faster and more relevant. 
The key thing for your team is this — the query language is SQL++. It's not a proprietary vector DSL. Your developers write the same queries they'd write for any Couchbase operation, just with a vector distance function added. 
No new syntax to learn, no separate search service to configure.
✅ So that’s the vector search with GSI requirement
[Action]: Type the next query:
Compare the horsepower ratings between the TDS-11SA and TDS-11HD. Which is more powerful and by how much?
[Wait for response]
[TT]: "This is where RAG gets interesting. The system pulled specs from two different sections of the PDF, compared them, and synthesized an answer. TDS-11SA has two 400 HP motors — 800 total. TDS-11HD has two 600 HP motors — 1,200 total. That's a 50% power increase. The LLM did the math using the actual document data. For supplier onboarding, imagine a vendor asking 'what's the difference between Tier 1 and Tier 2 compliance requirements?' — same pattern."
[Action]: Type the next query:
What field service and support options does NOV provide for top drive maintenance, and how can I reach them?
[Wait for response]
[TT]: "This pulls from the aftermarket operations section — field service, training, repair, tech support — and returns the 24/7 phone numbers and email. The vector search found chunks across multiple pages that were semantically relevant to 'maintenance support.' That's the power of semantic search over keyword matching."

Part 3: Semantic Cache (~4 min)
[TT]: "Now let me show you semantic caching. 
In any production chatbot, you're going to see the same questions over and over. If you're onboarding hundreds of suppliers, they're all going to ask 'what documents do I need to submit?' 
Semantic caching checks whether a new question is similar enough to a previously answered one and returns the cached response without calling the LLM. 
It saves you real money on API costs."
[TT]: So I’m going to type a query with different wording but same intent as the earlier support question:
Tell me the torque output and top speed of the TDS-11HD
How much torque and RPM can the TDS-11HD deliver at full capacity?
[Wait for response]
[TT]: "Watch the response time. 
[If cache hit]: That came back nearly quickly because the semantic cache recognized this is essentially the same question as our earlier one about TDS-11HD. 
The system computed cosine similarity between the query embeddings, found a match above the threshold, and returned the cached response without calling OpenAI. 
[If cache miss]: These were different enough to miss the cache — the similarity threshold is tunable, typically between 0.85 and 0.95. Let me try one closer."
[Action]: Type one more variation:
What support and service options are available for NOV top drives?
[Wait for response]
[TT]: "For your supplier onboarding chatbot, think about the economics. If 60-70% of supplier questions are variations of the same 20 questions, semantic caching could cut your LLM costs dramatically. And the cached responses live in Couchbase — same platform, same bucket, queryable with SQL++."
[Action]: Switch to Tab 3: Couchbase Server UI. [Action]: Navigate to the cache collection. [Action]: Click on a cached document to show structure.
[TT]: "Here's what a cached entry looks like — the original query, its embedding, and the cached LLM response. New queries get their embedding compared against this collection. If similarity is above the threshold, we skip the LLM. If not, we get a fresh answer and cache it for next time. All running in the same Couchbase cluster."

[TT]: "So that covers the first three capabilities — ingestion, vector search, and semantic caching — all running on one platform. Let me switch back to slides and show you agent memory."
[Action]: Switch back to slides. Advance to Slide 8.

Timing: ~15 minutes total for the live demo section
Notes: Have the queries pre-typed in a notes app so you can copy-paste rather than type live. If any query returns a weak response, don't panic — say "the chunking on that section may not have captured it cleanly, which is exactly why chunk size tuning matters in production" and move to the next query. The fallback query for any section is: "Tell me about the TDS-11HD top drive" — broad enough to always return good results.

⭐ The rag-demo uses PyPDFLoader from LangChain (backed by the pypdf library) to extract text from PDFs. Then it runs RecursiveCharacterTextSplitter with chunk_size=1500 and chunk_overlap=150 to break it into chunks. That's how your 12-page PDF became 19 documents — the splitter cuts at ~1500 characters per chunk with 150 characters of overlap between consecutive chunks so context isn't lost at boundaries.

## Slide 8 — Couchbase Agent Memory

[TT]: "Now let's talk about the fourth capability — agent memory."
[Action]: Advance to Slide 9. Same as the RAG divider — one sentence, move.

Timing: ~5 seconds
Notes: You just came out of a 15-minute live demo. This visual break lets the audience mentally shift gears. Don't add anything here — the next slide makes the case.

## Slide 9 — Why Agents Need Memory | Stateless Agents

[TT]: "This is the problem. 
Without memory, every session starts from zero. 
The user says 'Hi, I'm Alex' in session one. 
Session two, they ask 'what's my name?' and the bot has no idea. 
For your supplier chatbot, imagine a supplier spends 20 minutes filling out questions on Monday, comes back Wednesday, and the chatbot says 'how can I help you?' like they've never met. 
That’s a bad experience and it's a cost problem bc you're resending context every session, which inflates your token costs. 
And if you have multiple agents handling different parts of onboarding — compliance, financial review, safety certification — they're all operating in silos with no shared context. 
And…. That's what stateless looks like."
[Action]: Advance to Slide 10.

Timing: ~45 seconds
Notes: This slide is the "before" picture. Make it feel painful. Pause on "3x context resent" at the bottom — it quantifies the cost in a way builders care about. The next slide is the relief.

## Slide 10 — Why Agents Need Memory | Stateful Agents

[TT]: "Now here's what it looks like with memory. Session one, Alex says their name and that they like blue. That goes into short-term memory for the active session and gets extracted into long-term memory as persistent facts. Session two — different day, different session — the agent pulls from long-term memory and says 'welcome back, Alex.' No re-explanation needed. For your supplier onboarding chatbot, this means the system knows that Supplier X already submitted their safety certs, prefers email communication, and still has three outstanding items — without the supplier repeating any of it. And because the memory is a shared layer, every agent in your system — whether it handles compliance, financials, or safety — has access to the same unified context. No silos, no duplicate work, no broken handoffs."
[Action]: Advance to Slide 11.

Timing: ~45 seconds
Notes: This is the "after" picture. Mirror the structure of the previous slide — same scenarios, different outcome. The contrast does the selling. Hit the three benefits on the right briefly but don't read them — the audience can see them. Your job is to connect each one back to their supplier onboarding use case.

## Slide 11 — Model Providers

[TT]: "Here's how Couchbase Agent Memory is built. 
At the top you have your multi-agent system — which is whatever framework you're using. 
LangGraph, CrewAI, LlamaIndex, Strands — it's framework agnostic, no lock-in. 
Your agents talk to the Agent Memory Server through the Python SDK or REST API. 
The memory server handles two things: short-term memory — the last-N messages within a session — and long-term memory — facts, profiles, and summaries that persist across sessions. 
One API for both.
At the bottom, everything stores in your existing Couchbase cluster — KV, document, and vectors. No new infrastructure to introduce. 
And the memory server itself runs as a Docker container, so you can deploy it on any cloud or fully on-prem — which I know matters to NOV. 
 (IF TIME PERMITS) → I'm going to show you what this looks like running in a live application in a moment, but first let me show you one more thing."
[Action]: Advance to Slide 12.

## Slide 12 — Agent Memory | Multi Session Conversation

[TT]: "This is what multi-session memory looks like in practice. 
Day one — Alice asks the concierge to book Zuni Cafe for a client dinner. That conversation gets written into memory. 
Day two — completely new session — Alice asks 'what restaurant did you recommend last time?' The agent retrieves her context from the previous session and gives her the answer. Now look at the right side — this is the actual data structure stored in Couchbase. 
You've got the user ID that's consistent across sessions, 
the full conversation content, 
an auto-generated summary so you don't have to replay the entire history, 
the embedding vector for semantic search
 and extracted contexts — those are the personalization facts the system pulled out automatically. 
For your supplier onboarding chatbot, this is exactly how you'd track where a supplier is in the process. 
Monday they submit their financial disclosures. Thursday they come back and ask 'what do I still need to complete?' — the agent already knows. And your internal procurement team can query these same memory blocks to see supplier progress across the board."
[Action]: Advance to Slide 13.

Timing: ~75 seconds
Notes: This is your bridge between the architecture slide and the live demo. The JSON on the right is powerful for this audience — builders want to see the actual data model, not just diagrams. Point at the four numbered callouts (unique profile ID, full content, summary, extracted contexts) as you mention each one. The supplier onboarding mapping at the end is the last thing they hear before you show the live app — make it concrete.

## Slide 13 — Live Demo –Couchbase Agent Memory

[TT]: "Let me show you Couchbase Agent Memory through cross session memory and shared memory"
[Action]: Switch from slides to your browser. Share the screen with the agentmemory-sdk hotel demo (Tab 4).

LIVE DEMO — Agent Memory (8 min)
Part 1: Guest Portal — Cross-Session Memory (~4 min)
[TT]: "This is a hotel concierge demo we built at Couchbase. I’m going to use it to demonstrate cross session memory
The use case is different from supplier onboarding, but the architecture pattern is identical — multiple agents sharing one memory store in Couchbase. 
Think of the guest portal as your supplier-facing chatbot and the ops portal as your internal dashboard. 
[Action]: Select the Alice persona (corporate traveler with dense stay history).
[TT]: "I'm going to interact as Alice — she's a repeat guest with history across multiple stays. Like a supplier who's been through your onboarding process before."
[Action]: Type in the chat:
I'm arriving next week for my annual leadership retreat. Can you remind me what room type I preferred last time?
[Wait for response]
[TT]: "The concierge pulled Alice's preferences from previous sessions — stored in Couchbase under her user ID. 
It remembered her room preference across sessions. 
For supplier onboarding, this is how your chatbot knows that Supplier X already submitted their safety certifications but still needs their financial disclosures."
[Action]: Type a follow-up:
Also, can you make sure there is no seafood on the in-room dining menu? My husband is severely allergic.
Also, can you make sure there are no shellfish items on the in-room dining menu? My husband is severely allergic.
[Wait for response]
[TT]: "Two things just happened. 
First, the agent stored that allergy as a long-term fact in memory — it won't forget this next session. 
Second, this is a third-party fact — it's about Alice's husband, not Alice herself. The system handles that. 
So in the context of your onboarding app, imagine a supplier saying 'our CFO requires all documents to go through legal review first' — that's a process constraint about a third party that your chatbot should remember."

OPTIONAL → Show memory blocks in Couchbase
Query editor
Change user_id to alice_chen
Highlight raw message, summary of convo for fast retrieval and different contexts
Explain hierarchy Users → Sessions → Memory Blocks (delete a user, it deletes the dependencies of sessions and blocks)

Part 2: Operations Portal — Shared Memory (~3 min)
[TT]: So i’ll demonstrate the shared memory portion of this
[Action]: Switch to the operations portal (agentmemory-sdk ops UI).
[TT]: "Now I'm switching to the operations side — think of this as your internal dashboard. 
Same Couchbase cluster, same memory store, different view."
[Action]: Role: Front Desk - Arrivals
[Action]: Navigate to the Pre-Arrival Briefing or Safety/Allergy view for Alice. 
[Action]: Click Generate Briefing (Alice)
[TT]: "The allergy flag Alice just mentioned in the guest chat automatically surfaced here for the operations team. 
Both portals — guest-facing and internal — are reading and writing to the same Couchbase-backed memory store. 
This is the key insight: one memory store, multiple agents, with role-based access controlling who sees what. 
Guest agents write under the guest's namespace. E.g. concierge agent writes under Alice’s namespace…
Ops agents write under role namespaces — front desk, general manager, events. 
In your system, the supplier-facing chatbot writes to the supplier's namespace, and your internal teams reads from it with a broader view across all suppliers."

Part 3: Land It (~1 min)
[TT]: "What you just saw is eight LangGraph agents sharing one Couchbase memory store — cross-session recall, third-party facts, multi-agent coordination, role-based access. The memory is JSON documents in Couchbase — queryable, indexable, secured with RBAC. And because it's Couchbase, you get sub-millisecond memory lookups from a memory-first architecture. Let me switch back to slides."
[Action]: Switch back to slides. Advance to Slide 14.

Timing: ~8 minutes total for the live demo section
Notes: The hotel demo has pre-seeded data for Alice. Before the call, confirm Alice's persona is loaded and the guest portal responds to preference questions. If the ops portal takes a moment to reflect the allergy flag, fill the time by talking about the async write path: "The write path is asynchronous — memory gets processed in the background after the response is returned, so it doesn't add latency to the user experience." If anything fails, say "let me show you in Couchbase directly" and switch to the Server UI to show the memory block documents.


Default ops password is ops for every role, default chat password is 123 for every user.

## Slide 14 — Agent Memory | Comparison with Other Self-Managed Solutions

[TT]: "You've seen it working. Now here's how it stacks up. 
Your team has been experimenting with different tools, so this is worth a quick look. 
Couchbase Agent Memory checks every box — out-of-the-box (so you’re not building it yourself), enterprise support, framework agnostic, runs anywhere, and full traceability. 
Zep, Redis Memory Server and Mem0 are close, but they can't give you traceability — end-to-end agent traces with memory invocations for explainability. 
MongoDB is entirely DIY across the board. 
And LangChain LangMem locks you into one framework
The bigger point for your team is: with Couchbase, the memory layer runs on the same cluster as your vector store and cache. With any of these alternatives, you're adding another piece of infrastructure to manage, secure, and scale separately."
[Action]: Advance to Slide 15.

Timing: ~60 seconds
Notes: Don't read every cell in the table — the audience can see it. Hit the three that matter most: Couchbase is the only one with all checkmarks, MongoDB is entirely DIY, and the real differentiator is the single-platform story. If anyone asks about a specific competitor, you can go deeper in Q&A. If nobody on the NOV team mentioned a specific tool they're evaluating, keep this quick and move to the close. This slide works best as validation after the live demo, not as a selling point on its own.

## Slide 15 — What We Showed You

[TT]: "To bring it all together. 
You asked us to prove four things.
 Document ingestion — you saw me upload your own NOV PDF and watched it get chunked, embedded, and stored in Couchbase in under a minute. 
Vector search via GSI — you saw SQL++ queries pulling exact specs; all backed by Hyperscale vector indexes. 
Semantic caching — you saw a rephrased question return a cached response without hitting the LLM, saving cost and latency. 
And agent memory — you saw cross-session recall, third-party facts, and multi-agent memory sharing. 
All four on one Couchbase cluster. Both repos are open source — I'll share them with your team today. When you're ready to build against your actual supplier onboarding documents, let's scope a POC together."
[Action]: Pause. Let the slide sit for a beat. Then advance to Slide 16.

## Slide 16 — Thank you!

[TT]: "Happy to take any questions."
[Action]: Stop sharing screen if it helps the conversation feel more natural. Leave this slide up during Q&A.




RAG

Docs 
text — the raw chunk from page 6 of the PDF. RecursiveCharacterTextSplitter cut the 12-page PDF into ~1500-character overlapping windows. This particular chunk contains the specs table (drill pipe range, IBOP pressure, rotation, cooling, temperature range). The LLM sees this as context when answering. 
metadata — page number, source file, creation date, total pages. This is where the agent memory parallel gets interesting: in the agentmem collection, the equivalent is annotations (speaker, timestamp, session). Same concept — structured fields that let you filter before doing vector search, e.g. "only search chunks from page 5+" or "only search Alice's sessions from January."
embedding - the 1536-dim vector. Identical pattern to the agent memory collection. This is the universal interface: whether you're storing PDF chunks or , you embed them the same way and retrieve them the same way.

   RAG docs         │        Agent memory         │
  ├──────────────────────────┼─────────────────────────────┤
  │ text = PDF chunk         │ message = conversation turn │
  ├──────────────────────────┼─────────────────────────────┤
  │ metadata.page            │ annotations.timestamp       │
  ├──────────────────────────┼─────────────────────────────┤
  │ metadata.source          │ user_id / session_id        │
  ├──────────────────────────┼─────────────────────────────┤
  │ embedding = chunk vector │ embedding = turn vector     │
  └──────────────────────────┴─────────────────────────────┘

  The punchline for a technical audience: you don't need a separate vector database for RAG and a separate one for agent memory — Couchbase handles both in the s same cluster, queryable with the same SQL++.
