# GOV.UK Frontend Documentation

This project uses the [Tech Docs Template][template], which is a [Middleman template][mmt] that you can use to build technical documentation using a GOV.UK style.

You’re welcome to use the template even if your service isn’t considered part of GOV.UK, but your site or service must not:

- identify itself as being part of GOV.UK
- use the crown or GOV.UK logotype in the header
- use the GDS Transport typeface
- suggest that it’s an official UK government website if it’s not

👉 To find out more about setting up and managing content for a website using this template, see the [Tech Docs Template documentation][tdt-docs].

## Before you start

To run this project you need:

- [Ruby][install-ruby]
- [Middleman][install-middleman]
- [Node.js](https://nodejs.org/en/)

## Making changes

To make changes to the documentation for the Tech Docs Template website, edit files in the `source` folder of this repository.

You can add content by editing the `.html.md.erb` files. These files support content in:

- Markdown
- HTML
- Ruby

👉 Learn more about [configuring your website][configure].

## Installing dependencies

- run `bundle install` for Ruby dependencies
- run `npm install` for JavaScript dependencies

## Preview your changes locally

To preview your new website locally, navigate to your project folder and run:

```sh
bundle exec middleman server
```

👉 See the generated website on `http://localhost:4567` in your browser. Any content changes you make to your website will be updated in real time.

To shut down the Middleman instance running on your machine, use `ctrl+C`.

If you make changes to the `config/tech-docs.yml` configuration file, you need to restart Middleman to see the changes.

## Build

To build the HTML pages from content in your `source` folder, run:

```
bundle exec middleman build`
```

Every time you run this command, the `build` folder gets generated from scratch. This means any changes to the `build` folder that are not part of the build command will get overwritten.

## Troubleshooting

Run `bundle update` to make sure you're using the most recent Ruby gem versions.

Run `bundle exec middleman build --verbose` to get detailed error messages to help with finding the problem.

## Testing

To run the linter and Ruby tests, run `bundle exec rake`.

To check for broken links in the guidance, run `npm run check-link`.

## Licence

Unless stated otherwise, the codebase is released under [the MIT License][mit].
This covers both the codebase and any sample code in the documentation.

The documentation is [© Crown copyright][copyright] and available under the terms of the [Open Government 3.0][ogl] licence.

[mit]: LICENCE
[copyright]: http://www.nationalarchives.gov.uk/information-management/re-using-public-sector-information/uk-government-licensing-framework/crown-copyright/
[ogl]: http://www.nationalarchives.gov.uk/doc/open-government-licence/version/3/
[mmt]: https://middlemanapp.com/advanced/project_templates/
[tdt-docs]: https://tdt-documentation.london.cloudapps.digital
[configure]: https://tdt-documentation.london.cloudapps.digital/configure_project/
[install-ruby]: https://tdt-documentation.london.cloudapps.digital/create_project/get_started/#install-ruby
[install-middleman]: https://tdt-documentation.london.cloudapps.digital/create_project/get_started/#install-middleman
[gem]: https://github.com/alphagov/tech-docs-gem
[template]: https://github.com/alphagov/tech-docs-template
