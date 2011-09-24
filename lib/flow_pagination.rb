require 'will_paginate/view_helpers/link_renderer'

module FlowPagination

  # FlowPagination renderer for (Mislav) WillPaginate Plugin
  class LinkRenderer < WillPaginate::ViewHelpers::LinkRenderer

    # Render flow navigation
    def to_html
      flow_pagination = ''

      if self.current_page < self.last_page
        if @options[:noajax]
          flow_pagination = @template.link_to(
            @template.t('flow_pagination.link', :default => 'more'),
            url_for(self.next_page))
        else
          flow_pagination = @template.link_to_remote(
            @template.t('flow_pagination.link', :default => 'more'),
            {:url => url_for(self.next_page),
             :method => @template.request.request_method}.
              merge(ajax_options) )
        end
      end

      @template.content_tag(:div, flow_pagination, :id => 'flow_pagination')
    end

    def ajax_options
      return @ajax_options if @ajax_options
      @ajax_options = Hash[@options.select{ |k,v| [:loading, :loaded, :interactive, :success, :failure, :complete, :confirm, :condition, :before, :after, :submit, :with, :update, :position].include? k }]
    end

    protected

      # Get current page number
      def current_page
        @collection.current_page
      end

      # Get last page number
      def last_page
        @last_page ||= WillPaginate::ViewHelpers.total_pages_for_collection(@collection)
      end

      # Get next page number
      def next_page
        @collection.next_page
      end

  end

end
