# -*- coding: utf-8 -*-
require "text/hatena/node"

module Text
  class Hatena
    class TableNode < Node
      def init
        @pattern = /^\|([^\|]*\|(?:[^\|]*\|)+)$/
      end
      def parse
        c = @context
        l = c.nextline
        return unless @pattern =~ l
        t = "\t" * @ilevel

        c.htmllines("#{t}<table>")
        while l = c.nextline
          break unless @pattern =~ l
          l = c.shiftline
          c.htmllines("#{t}\t<tr>")
          l.scan(/([^\|]+)\|/) do |item|
            item = item[0] # ブロックの引数には配列が入っている
            if item.sub!(/^\*/, "")
              c.htmllines("#{t}\t\t<th>#{item}</th>")
            else
              c.htmllines("#{t}\t\t<td>#{item}</td>")
            end
          end
          c.htmllines("#{t}\t</tr>")
        end
        c.htmllines("#{t}</table>")
      end
    end
  end
end
