module Flagable
  module ActsAsFlagableController
    extend ActiveSupport::Concern
    included do

    end
    module ClassMethods
      def acts_as_flagable(options={})
        include Flagable::ActsAsFlagableController::LocalInstanceMethods
        extend Flagable::ActsAsFlagableController::LocalClassMethods
      end
    end
    module LocalClassMethods
   
    end
    module LocalInstanceMethods
      
      def flag
        fi = controller_path.classify.constantize::FLAG_ICONS
 
        @obj=controller_path.classify.constantize.find(params[:id])
        flg = params[:flag]
        lflag=("flag_"+params[:flag])
        authorize! lflag.to_sym, @obj
        unless params[:flag].nil? || params[:flag].empty? || params[:value].nil?
          if @obj.respond_to?(lflag+"=")
            @obj.send(lflag+"=",params[:value]=="true")
            @obj.save
          end
        end
        respond_to do |format|
#          format.html {render partial: "flags/flaglink", locals: {flag: params[:flag],icon: fi[params[:flag]]}}
          format.js { jq_render_replace(@obj.flaglinkid(flg), params[:flag]+ "is now" + params[:value]) { render_to_string inline:" <%= flag_link(@obj, params[:flag], params[:text],{class: params[:class]})%>"}} #}  partial: "flags/flag", locals: {flag: params[:flag], icon: fi[params[:flag]]}}
        end
      end
    end
  end

  module ActsAsFlagableRecord
    extend ActiveSupport::Concern
    included do

    end
    module ClassMethods
      def acts_as_flagable(options={})
        include Flagable::ActsAsFlagableRecord::LocalInstanceMethods
        #extend class methods
      end
    end
    module LocalInstanceMethods
      def get_flag(flag)
        v= @obj.send("flag_"+flag.to_s) if @obj.respond_to?("flag_"+flag.to_s)
        v= false if v.nil?
        v
      end
      def flaglinkid(flag)
        return self.class.to_s.gsub("::","_") + "_" + self.id.to_s + "_flag_"+flag.to_s
      end
    end
  end
  module FlagableHelper

    def flag_link(obj, flag, text="",d={})
      flag=flag.to_s
      fi = obj.class::FLAG_ICONS
      fc = obj.class::FLAG_CONFIRM
      value=obj.send("flag_"+flag)
      cstyle=(value) ? "true" :"false"
      cfm = (fc.nil? || fc["flag_"+flag].nil?) ?   {} : {confirm:  fc["flag_"+flag]}
      link_to  content_tag("i","", class: "ficon "+fi[flag].to_s ), url_for({controller: obj.class.name.tableize,action: :flag, flag: flag, value: !value, id: obj.id, class: d["class"].to_s+" "+d[:class].to_s}), remote: true, class:("flag-"+cstyle +" flag-"+flag + "-"+cstyle+ " "+d["class"].to_s+ " "+d[:class].to_s ), id: obj.flaglinkid(flag), data: cfm
    end
  end
end
ActionView::Base.send :include, Flagable::FlagableHelper
ActionController::Base.send :include, Flagable::ActsAsFlagableController
ActiveRecord::Base.send :include, Flagable::ActsAsFlagableRecord

