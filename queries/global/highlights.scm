; match line, block, or content nodes
((comment) @todo
 (#match? @todo "\\b(TODO|FIXME|TESTVALUE|IMPORTANT|BUG|HACK|NOTE)\\b"))

((block_comment) @todo
 (#match? @todo "\\b(TODO|FIXME|TESTVALUE|IMPORTANT|BUG|HACK|NOTE)\\b"))

((line_comment) @todo
 (#match? @todo "\\b(TODO|FIXME|TESTVALUE|IMPORTANT|BUG|HACK|NOTE)\\b"))

((comment_content) @todo
 (#match? @todo "\\b(TODO|FIXME|TESTVALUE|IMPORTANT|BUG|HACK|NOTE)\\b"))
