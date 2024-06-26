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
alias BookshelfEx.Books.Book
alias BookshelfEx.Users.User
alias BookshelfEx.Trades.Trade
alias BookshelfEx.Reservations.Reservation
alias BookshelfEx.Notifications.NotificationRequest

Repo.delete_all(Trade)
Repo.delete_all(NotificationRequest)
Repo.delete_all(Reservation)
Repo.delete_all(Book)
Repo.delete_all(User)
Repo.delete_all(BookshelfEx.Accounts.User)

Repo.insert!(%Book{
  title: "Kubernetes Up & Running",
  description: """
  In just five years, Kubernetes has radically changed the way developers and ops personnel build, deploy, and maintain applications in the cloud.
  With this book's updated third edition, you'll learn how this popular container orchestrator can help your company achieve new levels of velocity, agility, reliability, and efficiency--whether you're new to distributed systems or have been deploying cloud native apps for some time.
  Brendan Burns, Joe Beda, Kelsey Hightower, and Lachlan Evenson--who have worked on Kubernetes at Google and beyond--explain how this system fits into the life cycle of a distributed application.
  Software developers, engineers, and architects will learn ways to use tools and APIs to automate scalable distributed systems for online services, machine learning applications, or even a cluster of Raspberry Pi computers.
  This guide shows you how to: Create a simple cluster to learn how Kubernetes works Dive into the details of deploying an application using Kubernetes Learn specialized objects in Kubernetes, such as DaemonSets, jobs, ConfigMaps, and secrets Explore deployments that tie together the lifecycle of a complete application Get practical examples of how to develop and deploy real-world applications in Kubernetes
  """,
  cover_url: "https://m.media-amazon.com/images/I/81fH7yJ8rsL._SL1500_.jpg"
})

Repo.insert!(%Book{
  title: "Creating Software with Modern Diagramming Techniques",
  description: """
    Diagrams communicate relationships more directly and clearly than words ever can.
    Using only text-based markup, create meaningful and attractive diagrams to document your domain, visualize user flows, reveal system architecture at any desired level, or refactor your code.
    With the tools and techniques this book will give you, you'll create a wide variety of diagrams in minutes, share them with others, and revise and update them immediately on the basis of feedback.
  """,
  cover_url: "https://m.media-amazon.com/images/I/81Qu4QCh0PL._SL1500_.jpg"
})

book =
  Repo.insert!(%Book{
    title: "Programming Phoenix Liveview",
    description: """
    The days of the traditional request-response web application are long gone, but you don't have to wade through oceans of JavaScript to build the interactive applications today's users crave.
    The innovative Phoenix LiveView library empowers you to build applications that are fast and highly interactive, without sacrificing reliability. This definitive guide to LiveView isn't a reference manual.
    Learn to think in LiveView. Write your code layer by layer, the way the experts do.
    Explore techniques with experienced teachers to get the best possible performance.
    """,
    cover_url: "https://m.media-amazon.com/images/I/81KtOhfPCjL._SL1500_.jpg"
  })

user =
  BookshelfEx.Accounts.User.registration_changeset(%BookshelfEx.Accounts.User{}, %{
    email: "arturleite@deemaze.com",
    password: "1234567891012",
    account: %{
      first_name: "Artur",
      last_name: "Leite",
      office: :braga,
      is_admin: true
    }
  })
  |> Repo.insert!()

user =
  BookshelfEx.Accounts.User.registration_changeset(%BookshelfEx.Accounts.User{}, %{
    email: "pepas@deemaze.com",
    password: "1234567891012",
    account: %{
      first_name: "Pedro",
      last_name: "Batista",
      office: :braga
    }
  })
  |> Repo.insert!()

user =
  BookshelfEx.Accounts.User.registration_changeset(%BookshelfEx.Accounts.User{}, %{
    email: "monteiro@deemaze.com",
    password: "1234567891012",
    account: %{
      first_name: "João",
      last_name: "Monteiro",
      office: :coimbra
    }
  })
  |> Repo.insert!()

user =
  BookshelfEx.Accounts.User.registration_changeset(%BookshelfEx.Accounts.User{}, %{
    email: "johny@deemaze.com",
    password: "1234567891012",
    account: %{
      first_name: "João",
      last_name: "Oliveira",
      office: :coimbra
    }
  })
  |> Repo.insert!()

alias BookshelfEx.Reservations.Reservation

Repo.insert!(%Reservation{
  book: book,
  user: user.account
})
