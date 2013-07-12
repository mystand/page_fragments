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
      if @page_fragment.update_attributes(person_params)
        redirect_to :action => :index
      else
        render :edit
      end
    end

    private

    def person_params
      params.require(:page_fragment).permit(:key, :content)
    end
  end
end