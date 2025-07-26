#let __st-theme = state("theme")
#let __st-author = state("author")

#let item-pills(items, justify: true) = (
  context {
    let theme = __st-theme.final()

    set text(size: 0.85em, spacing: 0.5em)
    set par(justify: justify)

    block(items
      .map(item => box(
        inset: (x: 3pt, y: 3pt),
        stroke: theme.accent-color + 0.5pt,
        item,
      ))
      .join(" "))
  }
)

#let education(
  title: none,
  date: "",
  institution: "",
  degree: "",
  description,
) = {
  context block(above: 1em, below: 0.65em)[
    #let theme = __st-theme.final()

    #grid(
      columns: (1cm, 12.7cm),
      align: (right, left),
      column-gutter: .8em,
      [
        #text(size: 0.8em, fill: theme.font-color.lighten(50%), date)
      ],
      [
        #set text(size: 0.85em)

        #text(weight: "semibold", smallcaps([
          #title
          #h(1fr)
          #degree
        ]))

        #text(size: 0.9em, [#institution])
        #v(0.3em)

        #text(size: 0.9em, description)
      ],
    )
  ]
}

#let exp(
  company: "",
  date: "",
  position: "",
  summary: "",
  achievments: "",
  stack,
) = {
  context block(above: 1em, below: 0.65em)[
    #let theme = __st-theme.final()

    #grid(
      columns: (2cm, 11.7cm),
      align: (left, left),
      column-gutter: .8em,
      [
        #text(size: 0.7em, fill: theme.font-color.lighten(50%), smallcaps([
          #date.start
          #v(0em)
          #"-" #date.end
        ]))
      ],
      [
        #set text(size: 0.85em)

        #text(weight: "semibold", smallcaps([
          #company
          #h(1fr)
          #position
        ]))

        #summary
        #v(0.3em)
        #{
          for achieve in achievments [
            - #text(size: 0.9em, achieve)
          ]
        }

        #text(size: 0.9em, stack)
      ],
    )
  ]
}

#let activity(
  title: none,
  date: "",
  description,
) = {
  context block(above: 1em, below: 0.65em)[
    #let theme = __st-theme.final()

    #grid(
      columns: (1cm, 12.7cm),
      align: (right, left),
      column-gutter: .8em,
      [
        #text(size: 0.8em, fill: theme.font-color.lighten(50%), date)
      ],
      [
        #set text(size: 0.85em)

        #text(weight: "semibold", title)

        #v(0.3em)

        #text(size: 0.9em, description)
      ],
    )
  ]
}

#let contact-info() = (
  context [
    #let author = __st-author.final()
    #let theme = __st-theme.final()
    #let accent-color = theme.accent-color
    #let contact-items = ()

    #if "email" in author {
      contact-items += (
        [#author.email],
      )
    }

    #if "phone" in author {
      contact-items += (
        [#author.phone],
      )
    }

    #if "telegram" in author {
      contact-items += (
        [t.me/#author.telegram],
      )
    }

    #if "github" in author {
      contact-items += (
        [github.com/#author.github],
      )
    }

    #if contact-items.len() > 0 {
      table(
        columns: 20em,
        align: (left, left),
        inset: 0pt,
        column-gutter: 0.5em,
        row-gutter: 1em,
        stroke: none,
        ..contact-items
      )
    } else {
      []
    }
  ]
)

#let cv(
  author: (:),
  profile-picture: none,
  accent-color: rgb("#408abb"),
  font-color: rgb("#333333"),
  header-color: luma(50),
  date: datetime.today().display("[month repr:long] [year]"),
  heading-font: "Fira Code",
  body-font: "Fira Code",
  paper-size: "us-letter",
  side-width: 4cm,
  gdpr: false,
  footer: auto,
  body,
) = {
  context {
    __st-theme.update((
      font-color: font-color,
      accent-color: accent-color,
      header-color: header-color,
      fonts: (heading: heading-font, body: body-font),
    ))

    __st-author.update(author)
  }

  show: body => (
    context {
      set document(
        title: "Curriculum Vitae",
        author: (
          author.at("firstname", default: "")
            + " "
            + author.at(
              "lastname",
              default: "",
            )
        ),
      )

      body
    }
  )

  set text(font: body-font, size: 9.5pt, weight: "light", fill: font-color)

  set page(paper: paper-size, margin: (left: 12mm, right: 12mm, top: 10mm, bottom: 12mm), footer: if footer == auto {
    [
      #set text(size: 0.7em, fill: font-color.lighten(50%))
    ]
  } else {
    footer
  })

  set par(spacing: 0.75em, justify: true)

  let head = {
    context {
      block(
        width: 100%,
        fill: header-color,
        outset: (
          left: page.margin.left,
          right: page.margin.right,
          top: page.margin.top,
        ),
        inset: (bottom: page.margin.top),
      )[
        #align(center)[
          #let position = if type(author.position) == array {
            author.position.join(box(inset: (x: 3pt), sym.dot.c))
          } else {
            author.position
          }

          #set text(fill: white, font: heading-font)

          #text(size: 2em)[
            #text(weight: "medium")[#author.firstname] #text(
              weight: "medium",
            )[#author.lastname]
          ]

          #v(-0.5em)

          #text(
            size: 0.9em,
            fill: luma(200),
            weight: "regular",
          )[#smallcaps(position)]
        ]
      ]
    }
  }

  let side-content = context {
    set text(size: 0.72em)

    show heading.where(level: 1): it => block(width: 100%, above: 2em)[
      #set text(font: heading-font, fill: accent-color, weight: "regular")

      #grid(
        columns: (0pt, 1fr),
        align: horizon,
        box(fill: accent-color, width: -4pt, height: 12pt, outset: (left: 6pt)), it.body,
      )
    ]

    if profile-picture != none {
      block(
        clip: true,
        stroke: accent-color + 1pt,
        radius: side-width / 2,
        width: 100%,
        profile-picture,
      )
    }

    state("side-content").final()
  }

  let body-content = {
    show heading.where(level: 1): it => block(width: 100%)[
      #set block(above: 1em)

      #text(
        fill: accent-color,
        weight: "regular",
        font: heading-font,
      )[#smallcaps(it.body)]
      #box(width: 1fr, line(length: 100%, stroke: accent-color))
    ]

    body

    v(1fr)
  }

  head

  v(2mm)

  grid(
    columns: (side-width + 6mm, auto),
    align: (left, left),
    inset: (col, _) => {
      if col == 0 {
        (right: 6mm, y: 1mm)
      } else {
        (left: 6mm, y: 1mm)
      }
    },
    side-content,
    grid.vline(stroke: luma(180) + 0.5pt),
    body-content,
  )
}

/// Defines sidebar content for the CV.
/// - content (content): Content to display in the sidebar
#let side(content) = {
  context state("side-content").update(content)
}
