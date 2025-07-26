#import "utils.typ": contact-info, cv, education, exp, activity, side

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
      github: config.basic.github,
    ),
    profile-picture: image("photo.png"),
  )

  #side[
    = #config.titles.about
    = #config.titles.contact

    #contact-info()

    = #config.titles.skills
  ]

  = #config.titles.education

  #{
    for educationItem in config.education [
      #education(
        title: educationItem.title,
        institution: educationItem.institution,
        degree: educationItem.degree,
        date: educationItem.date,
        [
          #config.titles.diploma: #educationItem.diploma
        ],
      )

    ]
  }

  = #config.titles.exp

  #exp(title: "Data Scientist", institution: "Somewhere Inc.", location: "Somewhere, World", date: "2023 - Present", [
    - Worked on some interesting projects.
  ])

  = #config.titles.activities
]
