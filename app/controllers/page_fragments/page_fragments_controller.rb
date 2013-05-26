module PageFragments
  class PageFragmentsController < ApplicationController

    def index
      @page_fragments = PageFragment.all
    end

    def edit
      @page_fragment = PageFragment.find(params[:id])
    end

    def update
      @page_fragment = PageFragment.find(params[:id])
      if @page_fragment.update_attributes(params[:page_fragment])
        redirect_to :action => :index
      else
        render :edit
      end
    end
  end
end