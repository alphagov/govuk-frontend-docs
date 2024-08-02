// const { join, relative } = require('path')

const basePath = './node_modules/govuk-frontend/dist'
// const workspacePath = slash(relative(paths.root, basePath))
// const { HEROKU_APP, HEROKU_BRANCH = 'main' } = process.env

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
  basePath,
  entryPoints: ['./node_modules/govuk-frontend/dist/govuk/all.mjs'],
  tsconfig: './tsconfig.json',
  out: './jsdoc',

  // Turn off strict checks for JSDoc output
  // since `lint:types` will already log issues
  // compilerOptions: {
  //   allowJs: true,
  //   checkJs: true,
  //   esModuleInterop: true,
  //   module: "esnext",
  //   moduleResolution: "node10",
  //   noEmit: true,
  //   noImplicitThis: true,
  //   resolveJsonModule: true,
  //   strict: false,
  //   strictBindCallApply: true,
  //   strictFunctionTypes: true,
  //   target: "esnext",
  //   types: [],
  //   allowSyntheticDefaultImports: true,
  //   useDefineForClassFields: true
  // },

  // Document private methods. These are behind a checkbox in the
  // settings menu of the JSDoc page.
  excludePrivate: false,

  // Ignore known undocumented types (@internal, @private etc)
  intentionallyNotExported: ['I18n', 'TranslationPluralForms']
}
