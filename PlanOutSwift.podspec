Pod::Spec.new do |spec|
  spec.name         = "PlanOutSwift"
  spec.version      = "1.1.0"
  spec.summary      = "PlanOut interpreter implementation in Swift."
  spec.description  = <<-DESC
    A Swift implementation of PlanOut interpreter, for Swift or Objective-C backed front-ends. The implementation (tries to) follow standards defined by the Python implementation of PlanOut interpreter and also its Java implementation (planout4j).
                   DESC
  spec.homepage     = "https://github.com/irvifa/PlanOutSwift"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.authors            = {
    "Irvi Aini" => "irvi.fa@gmail.com"
  }
  spec.platform       = :ios, "9.3"
  spec.swift_version  = "5.0"
  spec.source       = { :git => "https://github.com/irvifa/PlanOutSwift.git", :tag => 'v' + spec.version.to_s }
  spec.source_files  = "Source/**/*.swift"
end
