// This file is part of the "jQuery.Syntax" project, and is distributed under the MIT License.
Syntax.brushes.dependency("trenni","xml");Syntax.brushes.dependency("trenni","ruby");Syntax.register("trenni",function(a){a.push({pattern:/((<\?r)([\s\S]*?)(\?>))/gm,matches:Syntax.extractMatches({klass:"ruby-tag",allow:["keyword","ruby"]},{klass:"keyword"},{brush:"ruby"},{klass:"keyword"})});a.push({pattern:/((#{)([\s\S]*?)(}))/gm,matches:Syntax.extractMatches({klass:"ruby-tag",allow:["keyword","ruby"]},{klass:"keyword"},{brush:"ruby"},{klass:"keyword"})});a.derives("xml")});
