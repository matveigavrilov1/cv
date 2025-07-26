#let __st-theme = state("theme")
#let __st-author = state("author")
/// Displays a list of items as "pills" (tags).
/// - items (array): List of items to display as pills
/// - justify (boolean): Whether to justify the pills (default: true)
#let item-pills(items, justify: true) = (
  context {
    let theme = __st-theme.final()

    set text(size: 0.85em, spacing: 0.5em)
    set par(justify: justify)

    block(
      items
        .map(item => box(
          inset: (x: 3pt, y: 3pt),
          stroke: theme.accent-color + 0.5pt,
          item,
        ))
        .join(" "),
    )
  }
)


// ---- Entry Blocks ----

/// Generic entry for education, experience, etc.
/// - title (string): Entry title
/// - date (string): Date or range
/// - institution (string): Institution or company
/// - location (string): Location
/// - description (content): Description/details
#let entry(
  title: none,
  date: "",
  institution: "",
  location: "",
  description,
) = {
  context block(above: 1em, below: 0.65em)[
    #let theme = __st-theme.final()

    #grid(
      columns: (2cm, auto),
      align: (right, left),
      column-gutter: .8em,
      [
        #text(size: 0.8em, fill: theme.font-color.lighten(50%), date)
      ],
      [
        #set text(size: 0.85em)

        #text(weight: "semibold", title)

        #text(size: 0.9em, smallcaps([
          #institution
          #h(1fr)
          #location
        ]))

        #text(size: 0.9em, description)
      ],
    )
  ]
}

/// Entry with a level bar (e.g., for skills).
/// - title (string): Item name
/// - level (int): Level value
/// - subtitle (string): Optional subtitle
#let item-with-level(title, level, subtitle: "") = (
  context {
    let theme = __st-theme.final()

    block()[
      #text(title)
      #h(1fr)
      #text(fill: theme.font-color.lighten(40%), subtitle)
      #level-bar(level, width: 100%)
    ]
  }
)

/// Displays the author's contact information (email, phone, address).
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
        columns: (12em),
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


// ---- Publications ----

/// Formats a publication entry (article, conference, etc.).
/// - pub (dictionary): Publication data
/// - highlight-authors (array): Authors to highlight
/// - max-authors (int): Max authors to display before "et al."
#let __format-publication-entry(pub, highlight-authors, max-authors) = {
  for (i, author) in pub.author.enumerate() {
    if i < max-authors {
      let author-display = {
        let author_parts = author.split(", ")
        let last_name = author_parts.at(0, default: author)
        let first_names_str = author_parts.at(1, default: "")

        let initials_content = first_names_str
          .split(" ")
          .filter(p => p.len() > 0)
          .map(p => [#p.at(0).])

        let joined_initials = if initials_content.len() > 0 {
          initials_content.join(" ")
        } else {
          []
        }

        if first_names_str == "" {
          [#last_name]
        } else {
          [#last_name, #joined_initials]
        }
      }

      if author in highlight-authors {
        text(weight: "medium", author-display)
      } else {
        author-display
      }

      if i < max-authors - 1 and i < pub.author.len() - 1 {
        if i == pub.author.len() - 2 {
          [ and ]
        } else {
          [, ]
        }
      }
    } else if i == max-authors {
      [_ et al_]
      break
    }
  }

  [. #pub.title.]

  let parent = pub.parent

  if parent.type == "proceedings" {
    [ in ]
  }

  [ #text(style: "italic", parent.title)]

  if "volume" in parent and parent.volume != none {
    [ #text(style: "italic", str(parent.volume)), ]
  }

  [ #pub.at("page-range", default: "")]

  if "date" in pub {
    [ (#pub.date).]
  }

  if "serial-number" in pub and "doi" in pub.serial-number {
    [
      doi: #link("https://doi.org/" + pub.serial-number.doi)[#text(style: "italic", str(pub.serial-number.doi))]
    ]
  }
}

// ---- Main CV Template ----

/// Main CV layout. Sets up theme, fonts, page, and structure.
/// - author (dictionary): Author information (firstname, lastname, etc.)
/// - profile-picture (image): Profile picture
/// - accent-color (color): Accent color for highlights
/// - font-color (color): Main text color
/// - header-color (color): Color for header background
/// - date (string): Date string for footer
/// - heading-font (string): Font for headings
/// - body-font (array): Font(s) for body text
/// - paper-size (string): Paper size
/// - side-width (length): Sidebar width
/// - gdpr (boolean): Add GDPR data usage in the footer
/// - footer (content): Optional custom footer
/// - body (content): Main content of the CV
#let cv(
  author: (:),
  profile-picture: none,
  accent-color: rgb("#408abb"),
  font-color: rgb("#333333"),
  header-color: luma(50),
  date: datetime.today().display("[month repr:long] [year]"),
  heading-font: "Fira Code",
  body-font: ("Fira Code"),
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

  set text(font: body-font, size: 10pt, weight: "light", fill: font-color)

  set page(
    paper: paper-size,
    margin: (left: 12mm, right: 12mm, top: 10mm, bottom: 12mm),
    footer: if footer == auto {
      [
        #set text(size: 0.7em, fill: font-color.lighten(50%))
      ]
    } else {
      footer
    },
  )

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
            #text(weight: "light")[#author.firstname] #text(
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
        box(fill: accent-color, width: -4pt, height: 12pt, outset: (left: 6pt)),
        it.body,
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