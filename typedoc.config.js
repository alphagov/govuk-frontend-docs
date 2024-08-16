// const { join, relative } = require('path')

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
}
