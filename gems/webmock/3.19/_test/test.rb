require "webmock"

WebMock::VERSION + WebMock.version

WebMock.enable!
WebMock.enable! except: 'hello'
WebMock.enable! except: ['hello', 'world']

WebMock.disable!
WebMock.disable! except: 'hello'
WebMock.disable! except: ['hello', 'world']
