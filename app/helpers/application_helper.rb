module ApplicationHelper
  def flash_method_class name
    {
      'alert' => 'container alert alert-warning alert-dismissible fade show',
      'notice' => 'container alert alert-success alert-dismissible fade show'
    }[name]
  end
end
