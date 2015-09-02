module ApplicationHelper
  
  def active_if_index_for?(name)
    'active' if current_page?(controller: name, action: 'index')
  end
  
end
