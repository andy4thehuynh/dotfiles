# Couchbase Developer Day (NOV) — Talk Track Exemplar

Voice exemplar. 3-hour session, multi-presenter, loose glyph-cued notes.
Glyph key as originally used:

- P / S / V — problem, solution, value
- T — task or topic being demoed
- Ex — example
- Compare — analogy
- 🙋 — audience question
- 👆 / 🖕 — pointer cue to a slide element
- 🚨 — emphasis beat

Slides with no notes are omitted.

## Slide 1 — Couchbase Developer Day

🏆 goal is to better understand CB capabilities and uncover possibilities for future applications at NOV.


Andy:
Simplify: 3 2 1 framework
Complex Ideas: Context, Core, Connect framework
Storytelling: Specificity (five senses), reliving vs reporting, and meaning
Tips: Nose breathing + conviction + presence


“Smile, engage, and enjoy it” -Brian

“Follows a tell-show-tell format to effectively convey capabilities of CB” -Jack

“Be excited you get to do this; you’ll look back with fond memories” -Kim

## Slide 2 — Agenda

CB platform → features & capabilities → breadth of the platform
Real world → Jeevan Moses share details of Operator + live demo off offline sync → see Couchbase in action
Common use cases
CB for AI → Darshana Eeshwar will touch on OneChat your team gets a sneak peak at Couchbase’s Agent Memory that will be GA in the next few months 


selected Couchbase as the best tool for long term gen AI storage

## Slide 3 — Jack Harper

Austin: AE → Dallas, TX → 4 years at Couchbase → has worked with NOV for a while → very familiar with your business

Jack: Dir of SE → San Fran, CA → just crossed 10yrs anniversary at CB → my manager

Andy: SE → Denver, CO → prev SWE for 8yrs creator economy creators helping coaches and entrepreneurs build and sell digital products and services

Brian: Sr SE → San Antonio, TX →  8 yrs at Couchbase → previously worked with NOV as a prospect & here to field questions

## Slide 7 — Powered by Couchbase: Always-on, Anywhere, Real-Time

🙋 “Show of hands, who here is familiar with Couchbase”

Even though we’ve been around since 2011, I’m surprised when I ask people how familiar they are with Couchbase.

It’s interesting, bc whether you know it or not, it’s already apart of your day to day. If you look at this slide, you probably do some this in your daily routine.

🖕From the moment you wake up and check one of your health apps, or if you’re streaming a show, if you’re ordering food, or tracking your… there’s a good chance that your experience is powered by Couchbase under the hood. 

I love this slide bc it has examples of how Couchbase can span across different industries. These industries have something in common too, they all depend on real time speed, offline capabilities, scale etc.

So any experience that must be fast, resilient, mobile first is a natural fit for Couchbase.

## Slide 8 — Couchbase | Architecture

What you’re seeing on this slide is what couchbase can do for you, today.

The key takeaway from Couchbase’s architecture is…

S: Couchbase consolidates caching, relational querying, vector search, and edge syncing into one secure, high-performance architecture you can deploy anywhere from cloud to rig.
Membase (memcached creators for speed/clustering) and CouchOne (Couchdb creators for document flexibility)
Membase’s SQLite storage layer + CouchDB’s robust JSON doc system

👆highlight eventing, real-time analytics, columnar storage

V: For you, this cuts software licensing costs and simplify operations by powering all your apps with a single database platform.

## Slide 9 — Couchbase | Data Model

🙋 “who here is familiar with CB’s data model?
Map relational to CB data model

S: Couchbase uses Scopes and Collections to organize JSON data, allowing you to logically separate drilling metrics from maintenance logs within a single database bucket.

V: How you organize your data directly impacts your RBAC granularity, query performance with SQL++, multi-tenancy isolation and replication topology without needing a separate database server.

## Slide 10 — Couchbase | Role Based Access Control

S: Couchbase RBAC gives you hierarchy of access control out of the box — assigning roles at the cluster level down to a collection so you can enforce the principle of least-privilege without custom middleware. 
This let’s you assign read/write permissions down to the exact equipment collection level.

👆 You’ll see two examples → User A example —> User B example

V: Secure operations, ensuring contractors only see what they need, all the while, preventing unauthorized modifications to your offshore rig data.

## Slide 11 — Scale on demand with automatic partitioning and rebalancing

P: let’s say there’s a sudden spike in telemetry data from a new drilling rig – this would crash legacy databases and cause downtime.

S: Couchbase uses an elastic architecture with automatic partitioning and memory-to-memory replication so you can scale horizontally without any application downtime.

👆 [orange arrow] App Server 1 uses a cached cluster map to send data to the ACTIVE node hosting active data (no middleware hops)
[red arrow] Active node streams data to replica partition

V:  Ensures high availability and fault tolerance to easily handle massive surges in equipment data and prevent costly monitoring.

CP = Consistency & Partition Tolerance. CB default for single cluster
A = Availability
AP = Multiple clusters with XDCR

## Slide 12 — Sample Dev Setup

S: *MDS - a feature that lets you assign specific services—like data, query, or indexing—to dedicated server nodes, allowing you to independently scale and optimize your workload based on hardware requirements — from a single dev node to 13+ production nodes — with zero application code changes.
V: Teams right-size infrastructure per workload at every stage of the SDLC, translating directly to predictable performance under production load.
👆 dev (docker container to build/test) → QA (colocate on small cluster to test) → prod (isolated to prevent resource contention)

Dev: A developer running a local Docker container on their laptop to build and test application features.
QA: A staging environment for integration testing, co-locating services on a small cluster to save costs while testing distributed behavior.
Production: A live high-traffic e-commerce site. Services are isolated onto dedicated, optimized hardware to scale independently and prevent resource contention.

## Slide 13 — Replication Between Clusters

Compare: Think of XDCR like a team collaborating in real-time on a massive global Google document; 
edits made anywhere are instantly and securely synced to everyone, 
If you and I make conflicting edits, they’re automatically resolved without breaking the file, 
and members can join or leave without ever interrupting the flow of information.

S: Couchbase XDCR solves this with a continuous, memory-to-memory replication protocol that automatically handles active-active conflict resolution, it’ll adjusts to cluster topology changes, and securely bridges completely different infrastructure environments.

V: You achieve globally distributed high availability and disaster recovery, ensuring applications serve data at local-memory speeds no matter where your users or infrastructure reside.

## Slide 14 — XDCR | High Availability & Global Resiliency

Ex: So that means, if an earthquake takes down your DC… or a cyberattack or there’s a power failure with the hardware, XDCR will continuously sync your data bidirectionally across multiple global regions to guarantee high availability. 

Global load balancer → knows user coming from → directs traffic to nearest cluster

## Slide 15 — Edge Computing

Edge Computing & Couchbase

## Slide 16 — Couchbase Mobile | Architecture

👆 What you see on this slide is the architecture for Couchbase Mobile which is highly optimized for applications that need to run in remote locations with poor internet connectivity.
Couchbase Mobile uses an embedded database on edge devices so that data stays local to the device
Sync Gateway to securely route data to the central server
Couchbase Server acting as your centralized data store to propagate data being synchronized upstream from a mobile phone, downstream so every edge device has the latest copy of the record

V: Your field workers and IoT sensors can read and write data offline, automatically syncing peer-to-peer or to headquarters once connection is restored.

## Slide 17 — Inter-Sync Gateway Replication | Concept

Intro: You might be wondering, how do we share massive amounts of equipment data with the cloud without losing packets during network outages. That’s where Inter-Sync Gateway Replication comes into play.

“mouthful”

S: Inter-Sync Gateway Replication allows pushing and pulling data securely between edge gateways, using either continuous streams or targeted one-time syncs.Ex: Continuous for real-time active-active topologies; One-Time for scheduled tasks e.g. seeding your db, cluster migrations and batch updates

V: You guarantee your data is always backed up, and reduces downtime risks even on spotty satellite connections.


ISGR – connects different Sync Gateway clusters across multiple data centers or edge networks, keeping your mobile data globally updated and highly available without having to route every change through your core database.
Continuous Replication:  mode where the replicator keeps a persistent WebSocket connection open and syncs changes immediately in both directions, rather than on a schedule.
Replicator: The sync engine built into Couchbase Lite. Runs in the background and continuously pushes local changes to SG and pulls remote changes down.

## Slide 18 — Access Control with Channels | Concept

👆 (gray text)

Compare: Think of Channels like security badges unlocking specific zones on a rig; technicians only access areas their role requires.

S: For the Access Control Model, we use Channels to tag JSON documents, so authorized users/roles get routed data specifically to them
👆 Users
👆 Roles

V: This fine-grained access control reduces synchronization time and secures operational data across your entire fleet.

Users: Individual rig workers (e.g., John).
Roles: Standardized badge clearance levels (e.g., "Lead Technician").
Channels: Restricted physical zones on the rig (e.g., "Drill Floor", "Control Room").
Relationship: John (User) is issued a "Lead Tech" badge (Role). This single badge unlocks both the "Drill Floor" and "Control Room" (Channels), granting him access to read or update all equipment logs (Documents) exclusively located within those secured zones.

## Slide 19 — Access Control Function | Definition

Next, we’ll see what this looks like at the application code layer.

S: Sync Gateway exposes a JavaScript function to validate user roles and permissions before accepting any document updates.

👆 [optional] function parameters accepts a newdoc, olddoc and metadata
Enforce data integrity if missing doc fields
Brand new document → cb provides built-in helper requireRole() checks if user has editor role
Updating document → verify user is listed as a previous writer (array)
Enforces write access by comparing
Use channel API to assign a doc to a channel 

👆 (Access Control API) + Access Control Function (first bullet)

V: That way, you guarantee absolute data integrity, ensuring the right field worker can alter maintenance logs down to a specific field.

## Slide 20 — Couchbase Mobile | Common Topologies

S: Couchbase offers flexible topologies, enabling peer-to-peer sharing and offline-first syncing across mobile, desktop, and embedded devices securely via WebSockets or REST. 

V: Your data is universally accessible across your entire fleet even during total network blackouts.

## Slide 21 — Couchbase Edge Server | Architecture

To wrap up this section, I wanted to touch on CB Edge Server.

S: Edge Server acts as a strategic hub in remote areas; powered by a Lite Core Engine (local storage, querying, and security) syncing data directly on local edge hardware.
Bi-directional data flow: syncing upstream to the central cloud (Sync Gateway) and downstream to local edge devices, HTTP clients, or sibling Edge Servers, enabling offline-first, distributed edge architectures.
Extremely minimal (runs on as little as 1GB RAM / single-board computers)

🚨V: You can run powerful, encrypted databases directly on rugged rig equipment, ensuring autonomous operations without needing massive on-site server racks.

## Slide 23 — Couchbase | Architected for AI-based Applications

Most companies are managing a separate AI db, just run their applications, which can create high-latency data silos, which causes data fragmentation 

👆 [clicks]

V: Allow you to build reliable AI apps and eliminates the cost and complexity of managing separate systems.

## Slide 24 — Couchbase Cluster

👆 you’ll see that this is a heavy slide of vsearch architecture; but I’ll walk you through it
[left to right]
Left → AI app connected to CB cluster
Right → zoom in to highlight how query + vector index enables vector search at scale processing billions of vectors with high QPS, low latency and good recall. 

👆 [define hyperscale, composite, search]

S: Together, these three indexes give you the freedom to match the right tool to the right workload – all under one unified platform.

Hyperscale Volume Index "Built for massive datasets and high-performance search, handling billions of vectors with ease. This proprietary engine is optimized for scale and speed."
Composite Vector Index "Focuses on simplicity and flexibility, reusing existing indexes to reduce management overhead. It’s ideal when high-selectivity filtering must happen before vector search."
Search Vector Index "Remains the go-to for text + vector hybrid search, combining semantic similarity with filters and structured data."

## Slide 25 — Agentic Apps | With Long Term Memory

S: Couchbase powers smart agents that combine semantic searches with an episodic memory of your past interactions to feed the LLM. 
The one thing you should know from this slide is that – we use the Couchbase Index Service not just for document retrieval but also as an episodic memory store. As the agent interacts with the user, it can embed and store key conversation, or "episodes," as vectors within the index. 

👆 When a new query comes in, the agent first performs a semantic query, against the knowledge base and collects/analyzes the results. Next, it, searches against the episodic memory (separate index).
This allows it to recall previous conversations or user preferences, which it can then use to inform its actions. 
Ex: if a user asks a follow-up question, the agent can retrieve the context of their previous conversation, allowing it to provide a more personalized and coherent response.

V: You get highly accurate and personalized recommendations that build upon historical data rather than starting from scratch every single time.



what is one word to describe when request

## Slide 33 — Live Demo

T: Demo login→ bucket/scope
S: Demo Credentials
V: Data isolation

T: Offline Sync → edge to cloud
S: Disable App Services → increment Artisan Bread inventory → query in Capella → enable App Services in iOS → rerun query
V: 

T: Capella iQ → generate SQL++ queries in natural language
S: Show me all items named "Artisan Bread"
V: Save time, develop quicker

T: Offline Sync → cloud to edge
S: Document Library → set collection to profile → search aa-store-01-profile → change phone number
V: 

T: P2P Sync
S: 
V: 
NOTE: 
The Android emulator runs on an isolated virtual network that blocks mDNS multicast traffic, which is what MultipeerReplicator uses to discover peers — so it can never find the iOS simulator even though both are on the same Mac
Both iOS simulators run directly on the Mac's real network interface, so their mDNS broadcasts reach each other without any NAT or virtual network in the way.



Troubleshooting:
Is cluster on?
Set IP address

iOS → open GroceryApp.xcodeproj
No profile change → click inventory tab, then profile tab

Web → Localhost:8080
Launch server → npm run dev
No inventory changes → refresh browser

Android → open -a "Android Studio"
Save File + Sync Project with Gradle Files

## Slide 34 — Demo Setup | Retail App

👆 A cross-platform demo of an inventory management app for grocery stores; [click] all running on a local network [click] And a central cloud database [click] syncing data to iOS, Android and web applications bidirectionally.

I’ll be demonstrating p2p sync between devices so that every device has the latest inventory of products as well as offline sync from edge to cloud, as well as cloud to edge.

## Slide 35 — Devices on a local network

👆 So what you just saw was Couchbase Lite embedded on the iOS simulators and android for local storage management [click], the same CB Lite powering web apps storing data locally using IndexedDB and CB Lite JS SDK [click], Couchbase Capella, our fully managed database as a service acting as the hub in this hub/spoke architecture [click] and Sync Gateway handling data routing in a secure fashion [click], all this is happening in real-time with a secure TLS connection.

👆 V: This architecture guarantees absolute business continuity and secure operations, ensuring yours app is working efficiently even entirely offline.

## Slide 36 — Devices on a local network

👆 Speaking of business continuity, let’s say we have a network outage and edge devices can’t communicate with the central server [click], how do you keep the business operational? [click] Couchbase provides two options:
The first is P2P sync which lets devices sync data directly over TLS, with automatic conflict resolution completely bypassing the need for a central server or internet connection. [click]
The second is CB Edge Server which acts as your local hub in areas with little to no connectivity [click]

👆 In the case of a Data Center outage [click], Couchbase’s built in feature called XDCR will handle memory to memory replication of your data to different geographical regions [click], that way, your business continues to operate, regardless of the stressful situation.

## Slide 37 — Devices on a local network

👆 Lastly, Couchbase supports vector search at the edge which solves the constraints of zero latency as well as privacy and compliance concerns. You simply add the Vector Search extension library provided by Couchbase to your project, alongside a lightweight embedding model… and you’re AI ready with the ability to search completely offline.


Embedding models: onnx, tflite or mlmodel

## Slide 43 — Leading utility company with more than 16 million customers 

👆 PG&E - one of the largest utility companies in the United States [read left pane] 

Powering Through the Storm
[setup]
I want you to put yourself in the shoes of a field technician for PG&E. It’s 2:00 AM. There’s a storm coming. You can feel the rain under your shirt, and you hear the crack in the power line next to you.
You’re standing in a remote canyon in the middle of nowhere. Your job right now:
figure out exactly which transformer blew, 
check the parts list to see if you have the replacement on your truck, 
and get the power back on. 
You pull out your tablet. You tap the Field Service app...
And you see the absolute worst thing you can see in right now: a spinning wheel and the words No Service. 
[The Conflict & The Stakes]
<finger> "For a utility company like PG&E, with over 16 million customers and 20,000 employees, this isn't just a mild inconvenience. It’s a matter of public safety. 
[The Turn: Mapping the Solution to the Demo]
To solve this, PG&E completely modernized their application architecture using Couchbase Enterprise and Couchbase Mobile. And the way they did it is exactly what we just saw in our Retail Demo.
Think about our grocery store manager doing inventory. When they walk into the back of a concrete warehouse where Wi-Fi goes to die, the app doesn't crash. They can still update the stock of soda on their iOS or Android device."
"Why? Because we brought the database to the edge."
[The Climax: Under the Hood]
"Out in that storm, our PG&E technician now opens their tablet and the infrastructure maps and customer accounts load instantly. This is because Couchbase Lite is embedded directly natively on their mobile device. The data lives right there in their hands."
"They complete the equipment inspection, log the repair, and update the work order—all completely offline."
"Now, the moment that technician gets back in their truck, drives down the mountain, and catches just a single bar of cell service... magic happens. Under the hood, Couchbase Sync Gateway immediately kicks in. Using highly efficient WebSockets, it securely synchronizes that data back to the cloud-hosted database server."
"Instantly, dispatchers miles away—looking at their Web App dashboards—see the status change to 'Resolved'. Other crews in the field get real-time updates to their parts lists. True collaboration, whether they are offline or online."
[The Meaning]
"The reason I’m telling you this is... true resilience isn't about having a perfect network. It’s about building applications that thrive when the network inevitably fails."
"By moving to this always-on edge architecture, PG&E didn't just build a better app. They enabled their teams to respond to service requests faster, automated their business processes, and drove down costs."
"Whether you are tracking grocery inventory in a warehouse, or restoring power to millions of people in a storm... Couchbase ensures your business never stops."




Rox: https://run.rox.com/customers/2cc3a449-3f9e-4399-9179-b317a0362388

https://www.couchbase.com/customers/pge/

pge.com

Industry: Energy & Utilities
Headcount: 28k
Revenue: $24.5B
Location: Oakland, CA

Unmatched scalability and consistent 500 ms response times for IP video platform with Couchbase
Leading utility company PG&E has more than 16 million customers and 20,000 employees. To work effectively over a huge geographic area, the company needs to provide PG&E gas and electric power inspectors in the field with real-time data, such as customer account information, utility infrastructure maps, and safety information. With Couchbase, the company can connect its teams with this data, whether they’re offline or online, while improving service and lowering the cost of field visits. Cross datacenter replication (XDCR) adds resiliency, ensuring workers can depend on the application to be available when they arrive at the job site.

Challenges
Build a foundational service request management platform to streamline and improve support
Microservices approach to move data from field to ERP, data services, customer-facing apps, and back again
Single source of truth for field technicians
Improve mobile development productivity and agility

Outcomes
Quickly respond to service requests and easily coordinate field teams
Improved asset/risk management
Real-time, relevant info for improved safety/quality
Multi-channel customer support
Fast, easy mobile development
Automated business processes speed service, lower costs for field work

20,000 employees - 16 million customers - 70,000+ square mile service area

## Slide 44 — Always-on mobile app named MyWorx provides maintenance on pr

👆 Total Energies is one of the 7 biggest publicly traded oil and gas companies in the world. They use Couchbase 

Powering the Extremes
[setup]
"Imagine you are standing in the middle of a massive, arid plain. The midday sun is absolutely blinding, beating down on your hardhat. Above you is the deafening, rhythmic whoosh, whoosh, whoosh of a 300-foot wind turbine slicing through the air. You can literally taste the grit of the dust blowing across the flatlands."
"You are a field service technician for TotalEnergies. You’ve just climbed down from inspecting the turbine's gearbox, and you need to log a critical wear-and-tear report into your MyWorx mobile app. If you don't report this, the turbine could fail, costing thousands of dollars in lost energy production."
"You pull off your heavy work glove, wipe the sweat from your screen, and look at your signal. Zero bars. You are miles away from the nearest cell tower."
[ Conflict & The Stakes]
"In the past, with a traditional cloud or on-premises database, a dead zone meant a dead app. The screen would freeze. Your work would stop. TotalEnergies was facing a massive paradox: their remote sites completely lacked internet connectivity, but their workers required absolutely 100% application uptime to keep the world's energy flowing."
[The Turn: Mapping the Solution to the Demo]
"TotalEnergies didn't just need a cloud migration; they needed a fundamental architectural shift. And they achieved it using the exact same offline-first mechanics we saw in our grocery store demo."
"Remember how our store manager could seamlessly continue counting cases of soda in a Wi-Fi dead zone? TotalEnergies applied that exact same power, but scaled it out to the most remote corners of the globe."
[Climax: Under the Hood]
"Because they built MyWorx on Couchbase Enterprise and Couchbase Mobile, they were able to embed Couchbase Lite directly onto the technician's ruggedized tablet. The entire database for that site lives right there in the device."
"Standing in the dust, entirely disconnected from the internet, our technician easily logs the gearbox report. The app is lightning-fast because the data is local. The job is done."
"Later that evening, when the technician drives back to the regional office and connects to Wi-Fi, the system takes over. Under the hood, Couchbase Sync Gateway kicks in. Using reliable, real-time data synchronization, it seamlessly pushes that maintenance report up to the cloud, instantly updating the central dashboard for the engineers back at headquarters."
[The Meaning]
"The reason I’m telling you this is... modernizing an application isn't just about moving servers from a basement into the cloud. It’s about unchaining your workforce from the limitations of connectivity."
"By adopting an offline-first mobile database, TotalEnergies guaranteed that their field service teams can successfully complete their work anytime and anywhere, completely independent of the internet. Whether you are tracking inventory in aisle five, or maintaining critical energy infrastructure in the middle of a desert... your business keeps running."


Rox: https://run.rox.com/customers/45b59ad1-fedb-4f5a-b220-99d4ae3ab367

Headcount: 100k
Revenue: $200B
Location: France

totalenergies.fr

41 on the Forbes Global 2000 (2025 list)

Use Case: TotalEnergies uses an offline-first mobile app they’ve named MyWorx to provide maintenance on pro- duction sites and to store data for reporting on their machines and equipment. This use case started by deploying 120 devices across 6 production sites in the UK, and the plan is to expand the app for use across additional international locations. Because both the CE to EE migration and the app roll- out in the UK went very smoothly, TotalEnergies is looking to repeat this success by using Couchbase to power additional apps.

CUSTOMER MOTIVATION: TotalEnergies wanted to modernize their mobile app by moving their database from on-premises to Azure so they could automate more processes and speed up development. Another motivation was security, and in particular, the lack of encryption on their devices.

See Win Wire PDF

## Slide 45 — Largest airline in the Middle East, operating over 3,600 fli

👆 Emirites is a major airline that generates $36b in revenue every year

Cleared for Takeoff
[setup]
“You are on the tarmac at Dubai International Airport. It is 115 degrees outside. And it reeks of jet fuel engine in the air
"You fix planes for a living for Emirates, and above you is an Airbus A380 with 500 passengers. Your job is to complete the preflight tech and cabin checklists. Every second you spend out here costs the airline money, and delays cascade across the world."
"Historically, you’d be standing out there holding a massive clipboard, flipping through a mountain of paper, hoping the wind doesn't rip a page out of your hand."
[Conflict & The Stakes]
"Emirates is the largest airline in the Middle East. They operate over 3,600 flights a week out of 154 airports. They desperately needed to digitize this slow, paper-based eTechlog system."
"But there’s a catch: inside a giant aluminum tube, or out on a concrete runway, Wi-Fi is notoriously awful. If they moved to a cloud-based app, and that app encountered a dead zone, the preflight process would be delayed. 
[The Turn: Mapping the Solution to the Demo]
"To solve this massive logistical challenge, Emirates looked to the exact same architecture we just explored in our retail demo."
"Think about our grocery app. We didn't rely on the cloud to count the soda inventory in a dead zone; we brought the database to the device. Emirates took that exact same offline-first approach and put it in the hands of their pilots and engineers."
[the Climax: Under the Hood]
"By deploying Couchbase Enterprise and Couchbase Mobile, Emirates embedded Couchbase Lite directly onto the crew's tablets. Now, when that engineer is deep in the cargo hold or walking the cabin, the eTechlog app responds instantly. There is zero latency because the data lives natively on the device."
"They tap through the safety checks, clear the aircraft, and hit submit. The app doesn't care if there's no internet."
"The moment that tablet catches a sliver of cellular or terminal Wi-Fi, the Couchbase Sync Gateway quietly and instantly takes over. It pushes that checklist data up to the cloud-hosted server. Immediately, every other tablet in the cockpit, and the dispatchers in the control tower, see the exact same current, updated status."
[Meaning]
"The reason I’m telling you this is... technology is only as good as the trust people place in it."
"Because Couchbase delivered 100% availability, Emirates saw incredibly high adoption and confidence from their crews. The app just worked, regardless of the internet connection."
"Whether you are a store manager scanning barcodes in an aisle, or an engineer clearing a jet for a 14-hour flight... when you remove the anxiety of connectivity, you empower your people to just get the job done."


Brian: flight attendant orders → research
Rox: https://run.rox.com/customers/b2702a68-d005-4c0f-a426-42eb0a2a4ccb 
Headcount: 116k
Revenue: $27.8B
Location: Dubai
Sales Motion: Land
Competitor: SQL Server
Industry: Transportation - Airlines, Airports & Air Services 
Cloud: Unknown
Use Case/Application: Adaptive Product Catalog
Product: Couchbase Enterprise, Couchbase Mobile / App Services
Key product features: Mobile
Emirates wanted to digitize their paper-based pre-flight check process, to modernize by using tablets to make it easier and faster for pilots and crew to complete this vital part of every flight. But the tablets would lose internet during inspections on the tarmac, and Emirates knew pilots wouldn’t use the app unless it was 100% reliable. By embedding Couchbase Lite to the tablets, the app works all the time, and the data is sync’ed to all the other tablets so the entire crew has the same information at once. And finally the data is synched to to the cloud as connectivity is available so that ground crews in the next airport have the same information. In this way, Couchbase Mobile helps Emirates maintain one of the best on-time and safety records in the industry.

150k+ flights / year
Emirates has developed a proprietary Electronic Technical Logbook (eTechlog) system to transition its aircraft maintenance records from paper to digital. Powered by database technologies like Couchbase, this customized, first-of-its-kind digital solution allows pilots and engineering teams to log and track aircraft defects and maintenance requirements in real time
ground crew refers to the team responsible for handling aircraft, passengers, and baggage on the ground before departure and after arrival, ensuring safe, efficient, and compliant operations.

## Slide 50 — Couchbase Agent Memory | Architecture

Diagram: file:///Users/andyhuynh/Downloads/AMS.html 

Running an application on Amazon EC2 instances – virtual servers in Amazon's cloud. 
The application has a public URL – it’s accessible over the internet, allowing users to interact with it through a browser or HTTP requests. 

Highlight components include: 
EC2 Instances: where the app is hosted, allowing it to be accessed online
Public URLs: Provides open access to the application for demo purposes, enabling potential users or clients to interact with it directly. 
Swagger UI API: This interface allows users to make HTTP requests to the agent memory server API, providing a way to experiment with the server's capabilities on their own machines
Couchbase UI: memory storage solution that retains context and other specific information, which allows the application to demonstrate how agent memory operates effectively. 
Users have access to the same Couchbase cluster, where each user can view their own memory blocks and user sessions. 
This setup helps potential users understand how their applications might function with agent memory, showcasing its ability to remember user interests and queries within sessions

## Slide 51 — Couchbase Agent Memory | TravelHub App

http://18.207.81.108:3000/

TravelHub: shows off the capabilities of agent memory. 
One without memory and another where personal details are injected using a memory block. 
Goal: the application can retain context-specific information, like user interests in street food and architecture when planning a trip to Tokyo. Such features highlight the practical applications of agent memory in enhancing user interactions within TravelHub

Steps:
HC: I like veg food
HC: I love smoothie (something on the screen)
Click → Save Last Exchange to Memory
TA: I'm planning to visit Italy from Bangalore this December.
TA: Recommend me good restaurants in Zurich which serves my favorite food.
QA: Recommend me good hotels which provide good workspace facilities in the place where I am you have to visit this December

Notes:
  - Single LLM call per turn — each request fires one chat.completions.create() and returns the response. No tool use, no function calling, no autonomous loops.
  - "Agents" are just personas — h1, h2, h3 are system prompts (Health Coach, Travel Assistant, Work Assistant), not autonomous processes.
  - The swarm "agents" are concurrent coroutines writing memory entries, not LLM agents reasoning through tasks.
  - AgentMem is the name of the memory SDK being tested — the "agent" in the name refers to the LLM-powered systems that would use this memory layer in production. 
  - This app is a sandbox for validating that the SDK correctly persists, retrieves, and isolates memory for those future agents
 the core problem it solves: LLM calls are stateless by default — every API call starts with a blank slate and knows nothing about prior conversations.

Agent Memory 
  - Remember that a user is vegetarian from a conversation 3 weeks ago
  - Pick up a conversation where it left off in a different session
  - Share relevant context across different agent personas (Health Coach knowing what the Travel Assistant discussed)

Data Model: User → Session (individual conversations) → Memory blocks (turn by turn exchanges, recalled 
Without a service like this, every chat is isolated — the LLM has no memory of who the user is. With it, agents behave more like a human assistant who actually remembers you.
The "agent" in the name isn't about autonomous task execution — it's about the type of system this memory is designed for: AI agents that converse with users over time and need continuity.

## Slide 52 — Couchbase Agent Memory | Memory Blocks as Documents

http://3.239.36.20:8091/ui/index.html
User: Administrator
Pass: password
Case sensitive


Memory block record is episodic memory — it stores a specific interaction that happened at a point in time, tied to a user, session, and timestamp. 
The agent can later retrieve "what happened during this conversation" rather than abstract facts about the user.

agent → agentmemory → memory / user / session

—


Memory:
  block_id — string (UUID)
  Unique identifier for this individual memory block, auto-generated at creation.
  Developer importance: Primary key for retrieving, updating, or deleting a specific memory block without scanning the full collection.

  user_id — string
  Reference to the user who owns this memory block, linking it back to the user document.
  Developer importance: Enables scoped memory retrieval — fetch only blocks belonging to a specific user during agent context assembly.

  session_id — string
  Reference to the session during which this memory block was created.
  Developer importance: Allows filtering memory by conversation session for session-scoped replay or context isolation.

  tokens — integer
  The token count of the combined message content in this block (likely user_content + assistent_content)
  Developer importance: Critical for staying within LLM context window limits when assembling retrieved memories into a prompt.

  message — object
  Container for the raw conversational exchange, holding two sub-fields:
  Developer importance: preserves the raw conversation exchange so the agent can reference exactly what was said 

  - user_content — string: The verbatim input submitted by the user.
  Developer importance: Preserved as ground truth for the user's original intent, useful for reprocessing or auditing.

  - assistant_content — string: The verbatim response generated by the agent.
  Developer importance: Stored alongside user input to maintain full conversational context for future memory retrieval.

  fact — string | null
  A distilled factual statement extracted from the message; null if no discrete fact was identified.
  Developer importance: Enables fast fact-based lookups without re-parsing full message content during retrieval.

  ingested_at — string (ISO 8601 datetime)
  UTC timestamp when the block was first written to Couchbase.
  Developer importance: Useful for auditing pipeline latency and diagnosing delays between conversation and memory availability.

  created_at — string (ISO 8601 datetime)
  UTC timestamp when the memory block record was formally created.
  Developer importance: Used for chronological ordering of memories and TTL-based expiration policies.

  last_queued_at — string (ISO 8601 datetime)
  UTC timestamp of the most recent time this block was queued for processing (e.g. embedding generation or summarization).
  Developer importance: Helps detect stale or stuck blocks that were queued but never fully processed.

  fail_count — integer
  Number of times processing has failed for this block.
  Developer importance: Enables dead-letter logic — isolates corrupted memory blocks after repeated failures so you’re not stuck trying to process bad data

  annotations — object
  Key-value map tagging the block with metadata such as which agent configuration produced it.
  Developer importance: Supports filtering and debugging by agent version, useful for A/B testing memory quality across agent configs.

  embedding — array[float]
  High-dimensional vector representation of the block's content, generated by an embedding model.
  Developer importance: The core artifact powering semantic similarity search — Couchbase uses this to retrieve contextually relevant memories via vector index. 1536 dimensions + OpenAI text-embedding-3-small

  summary — string
  A condensed natural language summary of the full message exchange in this block.
  Developer importance: Injected into the agent's prompt as compressed context, reducing token usage while preserving semantic meaning.

  contexts — array[string]
  Discrete, standalone facts or observations extracted from the message exchange.
  Developer importance: Granular units of knowledge the agent can retrieve and inject individually, enabling precise context assembly without loading full message history.

  status — string (enum)
  Processing state of the memory block, indicating whether it is ready for retrieval or still being processed.
  Developer importance: Gates whether a block is included in retrieval — querying blocks with non-ready statuses would inject incomplete or unembedded memory into the agent.


User:
  id — string
  Unique identifier for the user record, typically matching the user_id referenced across sessions and memory blocks.
  Developer importance: Primary key for the user document — used to join session and memory data back to a specific user.

  name — string
  Human-readable display name associated with the user account.
  Developer importance: Useful for logging, debugging, and personalizing agent responses without needing a separate identity lookup.

  sessions — array[string]
  List of session IDs associated with this user, each referencing a session document in Couchbase.
  Developer importance: Acts as an index for retrieving a user's full conversation history without a full collection scan.

  metadata — object
  Extensible key-value store for arbitrary user-level context such as preferences, locale, or feature flags.
  Developer importance: Schema-flexible space for attaching user-specific data that varies by deployment or product requirements.


Session:
  user_id — string
  Unique identifier scoped to the end user, generated at account creation or first session init.
  Developer importance: Primary lookup key for retrieving all sessions and memory blocks belonging to a specific user.

  session_id — string
  Unique identifier for a single conversational session, grouping all messages and memory within that interaction window.
  Developer importance: Scopes context retrieval to one conversation, preventing cross-session memory bleed.

  start_time — string (ISO 8601 datetime)
  UTC timestamp recorded when the session was first initialized.
  Developer importance: Used for ordering sessions chronologically and implementing TTL-based cleanup on stale sessions.

  end_time — string | null (ISO 8601 datetime)
  UTC timestamp recorded when the session closed; null means the session is still active.
  Developer importance: Distinguishes live vs. completed sessions and identifies abandoned sessions for garbage collection.

  annotations — object
  Free-form key-value map for tagging the session — commonly used to label which agent configuration or persona handled it.
  Developer importance: Enables filtering by agent version for A/B testing and targeted debugging without schema changes.

  metadata — object
  Extensible key-value store for arbitrary session-level context that doesn't fit predefined fields.
  Developer importance: Schema-flexible escape hatch for environment-specific data without altering the core document structure.

  blocks_ttl — integer | null (seconds)
  Time-to-live applied to memory blocks for this session; null means blocks persist until explicitly deleted.
  Developer importance: Controls memory retention per session for cost management and compliance with data retention policies.



Metadata:
  id — the document key, here combining a user/session identifier in the format demo-<user>/session-<id>
  rev — the revision token Couchbase uses for optimistic concurrency control; the leading 3 means this document has been mutated 3 times
  expiration — TTL in seconds until the document is auto-deleted; 0 means it never expires
  flags — a 32-bit integer encoding the data format and SDK type hints used during serialization; 33554432 indicates JSON
  type — the data format of the document body, confirming it is stored as JSON
  xattrs — extended attributes, a separate metadata namespace Couchbase provides for SDK/system use; empty here means none have been set

## Slide 53 — Couchbase Agent Memory | SDK Explorer

http://18.207.81.108:8000/docs#/ 

SDK Explorer:  to demonstrate how things work under the hood by providing a code comparison on the screen. 
When conducting these comparisons, it helps showcase scenarios side-by-side, such as conversations with and without memory to illustrate the power of agent memory. 
This tool is integral for allowing developers and users alike to understand the inner workings of the application architecture and the implementation of agent memory within it

Travel App Hub → Endpoints for the multi-agent travel demo — chat interactions routed through Health Coach, Travel Assistant, and Work Assistant agents. Value: lets you test how AgentMem persists and retrieves per-user memory across different agent personas.
Swarm Load Tester → Endpoints for launching concurrent multi-agent scenarios against AMS. Value: stress-tests AgentMem's isolation and performance under parallel load — verifies agents don't bleed memory across tenants at scale.
Default → Likely the health/validation runner endpoints (CRUD assertions against AMS). Value: systematic pass/fail verification of core AMS operations — user lifecycle, session management, cascade deletes, etc.
SDK Explorer → Endpoints that run the fixed 3-turn side-by-side scenario (with vs. without AgentMem). Value: produces a direct comparison demonstrating what the SDK adds — useful for demos and regression checks.

## Slide 54 — Couchbase Agent Memory | Swagger API

32.198.39.204:8080/docs

Swagger UI API: This interface allows users to make HTTP requests to the agent memory server API, providing a way to experiment with the server's capabilities on their own machines

## Slide 55 — Couchbase Agent Memory | Repo

Clarify: demo branch, not main branch

## Slide 59 — Couchbase Platform| Key Takeaways

Let’s recap what we have learnt about the architectural and design differentiators of Couchbase Data Platform…
We talked about these along the five pillars which are…
Elastic Architecture...
Built-in High Availability…
Performance at Scale…
Cloud to Edge Deployment …
Develop & Run Easily…

Our Elastic Architecture comes from our foundation of being designed as a sharded and replicated database from Day 1… 100% of our customers rely on sharding and automatic online rebalance…as a result application code remains unchanged whether you are running on 1 node on your laptop, or on 3 nodes in a test environment, or on 20 nodes in production…

Our gold standard Built-in High Availability comes from automatic replication of data across nodes,  built in rack-zone awareness with smart data placement, and fast automatic failover within seconds…

Not only do we have high performance with our built-in fully managed object cache for in-memory speeds, we also have a high performance storage engine for disk bound workloads…Not only do we promise high performance, we also ensure that this performance scales as your workload and data scales….Add to all this the billion scale vector indexes with best in class performance…

Couchbase architecture allows for maximum flexibility in deployment topologies to meet the applications users and administrators where they are. We have active-active XDCR to allow for global deployments for globally distributed users. We allow for multi and hybrid cloud deployments with our Capella DBaaS. We also support cloud to edge topologies with automatic data synchronization to potentially offline or low resource environments on the edge…

And last but not least,...all this comes with the ability to Develop and Run your applications easily on Couchbase…This is enabled by a declarative SQL like query language on a flexible document model plus native programmatic SDKs in all the major languages. There are integrations and connectors available for the key AI ecosystem tools. And to help you test, run and operate easily all of the Couchbase capabilities are available on all deployment choices - including physical hardware directly, virtualized environments, containers, public cloud and as our fully managed service Capella.

## Slide 61 — Next Steps + Q&A

Highlighting the benefits and unique capabilities of Couchbase, particularly how it supports edge computing and AI features. 
Inviting the audience to check out the prepared repository and demo materials to explore Couchbase's functionalities hands-on. 
Please reach out
Encouraging them to engage with Couchbase for further insights on implementing technical solutions discussed in the presentation, emphasizing any available professional services that could aid their projects

Sending info after workshop, happy to talk about deeper with CB and your use cases via POC or PS

## Slide 62 — Thank you!

Thanks Nishanth - scrambling to setup agent memory to demo regardless of the restrictions of GA

## Slide 64 — Use Case Example | Offline-First Field Work

One of the most powerful scenarios for edge vector search is offline-first field work.

Before heading into the field, workers sync documents and embeddings to their devices while they still have connectivity.

Later, at remote or disaster recovery sites — where network access is limited or nonexistent — they can still search locally using natural language.

With traditional search, this would require maintaining complex synonym lists.

With vector search, context and meaning are captured automatically.

Searching for “exposed cable,” for example, can surface documents related to downed power lines, high-voltage cables, or safety procedures — all without the cloud.

The app generates embeddings locally and runs vector search directly against the on-device data, delivering relevant results exactly when they’re needed most.
