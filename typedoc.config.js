const typedoc = require('typedoc')

/**
 * @type {import('typedoc').TypeDocOptions}
 */
module.exports = {
  // disableGit: !!HEROKU_APP,
  emit: 'both',
  name: 'govuk-frontend',
  // sourceLinkTemplate: HEROKU_APP
  //   ? `https://github.com/alphagov/govuk-frontend/blob/${HEROKU_BRANCH}/${workspacePath}/{path}#L{line}`
  //   : `https://github.com/alphagov/govuk-frontend/blob/{gitRevision}/{path}#L{line}`,

  // Configure paths
  basePath: './node_modules/govuk-frontend/dist',
  entryPoints: ['./node_modules/govuk-frontend/dist/govuk/all.mjs'],
  tsconfig: './tsconfig.json',
  out: './jsdoc',

  // Document private methods. These are behind a checkbox in the
  // settings menu of the JSDoc page.
  excludePrivate: false,
  
  // Because `govuk-frontend` is in `node_modules`, TypeDoc would consider it
  // 'external'. As it's what we're documenting, we'll instead treat anything
  // that's not in the govuk-frontend package 'external'
  externalPattern: ['!**/node_modules/govuk-frontend/**'],

  plugin: [
    // Use typedoc-plugin-missing-exports to ensure that internal symbols which
    // are not exported are included in the documentation (like the `I18n` class
    // or the components' config types)
    'typedoc-plugin-missing-exports'
  ],
  // By default, missing-exports will regroup all symbols under an `<internal>`
  // module whose naming is a bit poor. Instead, we let the symbols be displayed
  // alongside the others
  placeInternalsInOwningModule: true,
  // The missing-exports plugin will include built-in symbols, like the DOM API.
  // We don't want those in our documentation, so we need to exclude them
  excludeExternals: true,

  // Make TypeDoc aware of tags we use but it does not parse by default
  // so it doesn't warn unnecessarily
  modifierTags: [
    ...typedoc.Configuration.OptionDefaults.modifierTags,
    '@preserve',
    '@constant'
  ]
}
