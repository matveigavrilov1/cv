#import "utils.typ": activity, contact-info, cv, education, exp, side

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

  #{
    for expItem in config.exp [
      #exp(
        company: expItem.company,
        date: expItem.date,
        position: expItem.position,
        achievments: expItem.achievments,
				[#config.titles.stack: #expItem.stack]
      )
    ]
  }

  = #config.titles.activities

  #{
    for activityItem in config.activities [
      #activity(
        title: activityItem.title,
        date: activityItem.date,
        activityItem.description
      )
    ]
  }
]
