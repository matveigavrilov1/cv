#import "utils.typ": cv, contact-info, side, entry

#let main(
  config: none,
) = [
  #show: cv.with(
    author: (
      firstname: config.basic.firstname,
      lastname: config.basic.lastname,
      position: config.basic.position,
      phone: config.basic.phone,
      email: config.basic.email,
      telegram: config.basic.tg,
      github: config.basic.github
    ),
    profile-picture: image("photo.png"),
  )

  #side[
    = About Me
    = Contact
    
    #contact-info()

    = Skills
  ]

  = Education

  #entry(
    title: "Master of Science in Data Science",
    institution: "University of Somewhere",
    location: "Somewhere, World",
    date: "2023",
    [Thesis: "My thesis title"],
  )

  = Experience

  #entry(
    title: "Data Scientist",
    institution: "Somewhere Inc.",
    location: "Somewhere, World",
    date: "2023 - Present",
    [
      - Worked on some interesting projects.
    ],
  )
]