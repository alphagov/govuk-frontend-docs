module Ext
  module GovukTechDocs
    module TechDocsHTMLRenderer
      module ResetUniqueIndentifierGeneratorPreprocess
        ##
        # Fix for the unique ID generation not being reset for each document
        # leading to IDs being considered duplicates when on different pages
        # while they shouldn't be
        #
        # @see https://github.com/alphagov/tech-docs-gem/issues/310

        def preprocess(document)
          ##
          # Resets the UniqueIdentifierGenerator before the document gets processed
          #
          # @see https://github.com/vmg/redcarpet#prepost-process

          ::GovukTechDocs::UniqueIdentifierGenerator.instance.reset

          document
        end
      end
    end
  end
end
