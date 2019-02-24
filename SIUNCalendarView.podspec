#
# Be sure to run `pod lib lint SIUNCalendarView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'SIUNCalendarView'
    s.version          = '1.0.0'
    s.summary          = 'Swift CalendarView'
    s.description      = <<-DESC
    Swift CalendarView at Bodabi App
    DESC
    
    s.homepage         = 'https://github.com/l-hyejin/SIUNCalendarView'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'l-hyejin' => 'knca2@naver.com' }
    s.source           = { :git => 'https://github.com/l-hyejin/SIUNCalendarView.git', :tag => s.version.to_s }
    s.ios.deployment_target = '9.0'
    
    s.source_files = 'SIUNCalendarView/Classes/**/*'
    s.swift_version = '4.2'
end
