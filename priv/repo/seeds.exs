# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     BookshelfEx.Repo.insert!(%BookshelfEx.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias BookshelfEx.Repo
alias BookshelfEx.Reservations.Reservation
alias BookshelfEx.Accounts

Repo.insert!(%BookshelfEx.Books.Book{
  title: "Kubernetes Up & Running",
  description: "
 In just five years, Kubernetes has radically changed the way developers and ops personnel build, deploy, and maintain
applications in the cloud. With this books's updated third edition, you'll learn how this popular container orchestrator
can help your company achieve new levels of velocity, agility, reliability, and efficiency--whether you're new to
distributed systems or
 have been deploying cloud native apps for some time. Brendan Burns, Joe Beda, Kelsey Hightower, and Lachlan Evenson--
who have worked on Kubernetes at Google and beyond--explain how this system fits into the life cycle of a distributed
application. Software developers, engineers, and architects will learn ways to use tools and APIs to automate scalable
distributed systems for online services, machine learning applications, or even a cluster of Raspberry Pi computers.
  gui shows you how to:
 Create a simple cluster to learn how Kubernetes works Dive into the details of deploying an application using
Kubernetes Learn
 specialized objects in Kubernetes, such as DaemonSets, jobs, ConfigMaps, and secrets Explore deployments that tie
together the lifecycle of a complete application Get practical examples of how to develop and deploy real-world
applications in Kubernetes
",
  cover_url: "https://m.media-amazon.com/images/I/81fH7yJ8rsL._SL1500_.jpg"
})

Repo.insert!(%BookshelfEx.Books.Book{
  title:
    "Creating Software with Modern Diagramming Techniques: Build Better Software with Mermaid",
  description: "
  Diagrams communicate relationships more directly and clearly than words ever can. Using only text-based markup, create
meaningful and attractive diagrams to document your domain, visualize user flows, reveal system architecture at
any desired level, or refactor your code. With the tools and techniques this books will give you, you'll create a wide
variety of diagrams in minutes, share them with others, and revise and update them immediately on the basis of feedback.
 Adding diagrams to your professional vocabulary will enable you to work through your ideas quickly when working on your
 own code or discussing a proposal with colleagues.
Expand your professional vocabulary by learning to communicate with diagrams as easily and naturally as speaking or
writing.
This books will provide you with the skills and tools to turn ideas into clear, meaningful, and attractive diagrams in
mere minutes, using nothing more complicated than text-based markup. You'll learn what kinds of diagrams are suited to
each of a variety of use cases, from documenting your domain to understanding how complex code pieces together.
 Model your software's architecture, creating diagrams focused broadly or narrowly, depending on the audience.
Visualize application and user flows, design database schemas, and use diagrams iteratively to design and refactor your
application. You'll be able to use technical diagramming to improve your day-to-day workflow. You will better
understand the codebase you work in, communicate ideas more effectively and immediately with others, and more clearly
 document the architecture with C4 diagrams. Manually creating diagrams is cumbersome and time-consuming.
 You'll learn how to use text-based tools like Mermaid to rapidly turn ideas into diagrams. And You'll learn how to
keep your diagrams up to date and seamlessly integrated into your engineering workflow. You'll be better at visualizing
and communicating when you add diagrams to your standard vocabulary.
",
  cover_url: "https://m.media-amazon.com/images/I/81Qu4QCh0PL._SL1500_.jpg"
})

%Accounts.User{}
|> Accounts.User.registration_changeset(%{
  email: "arturleite@test.com",
  password: "1234567891011",
  first_name: "Artur",
  last_name: "Leite"
})
|> Repo.insert!()

Repo.insert!(%Reservation{
  user_id: 1,
  book_id: 1
})
