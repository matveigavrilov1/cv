#import "utils.typ": activity, contact-info, cv, education, exp, side

#let main(
  config: none,
) = [
  #show: cv.with(
    author: (
      firstname: config.basic.firstname,
      lastname: config.basic.lastname,
      position: config.basic.position,
      phone: config.contact.phone,
      email: config.contact.email,
      telegram: config.contact.tg,
      github: config.contact.github,
    ),
    profile-picture: image("photo.png"),
  )

  #side[
    #config.basic.age

    #config.basic.city
    #v(-1em)
    = #config.titles.summary

    #config.summary

    #v(-1em)
    = #config.titles.contact

    #contact-info()

    #v(-1em)
    = #config.titles.skills
	
    #{
      for skill in config.skills [
        #skill.title
        #v(0em)
        #{
          for item in skill.items [
            - #item
          ]
        }
        #v(1em)
      ]
    }
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
        summary: expItem.summary,
        achievments: expItem.achievments,
        [#config.titles.stack: #expItem.stack],
      )
    ]
  }

  = #config.titles.activities

  #{
    for activityItem in config.activities [
      #activity(
        title: activityItem.title,
        date: activityItem.date,
        activityItem.description,
      )
    ]
  }
]
