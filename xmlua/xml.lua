local XML = {}

local libxml2 = require("xmlua.libxml2")
local ffi = require("ffi")

local Document = require("xmlua.document")

function XML.build(tree)
  local raw_document = libxml2.xmlNewDoc("1.0")
  return Document.build(raw_document, tree)
end

function XML.parse(xml, options, extra_parse_options)
  local context = libxml2.xmlNewParserCtxt()
  if not context then
    error("Failed to create context to parse XML")
  end
  local document = libxml2.xmlCtxtReadMemory(context, xml, options, extra_parse_options)
  if context.lastError.message ~= ffi.NULL then
    if context.lastError.message == ffi.NULL then
      error("Failed to parse XML")
    else
      error("Failed to parse XML: " .. ffi.string(context.lastError.message))
    end
  end
  return Document.new(document)
end

return XML
