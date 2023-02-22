import ApiMiddlewareLive
import Dependencies
import SharedModels
import SiteMiddleware
import SiteRouter
import Vapor
import VaporRouting

/// Configure the vapor application with the dependencies, middleware, routes, etc.
///
/// - Parameters:
///    - app: The vapor application to configure.
public func configure(_ app: Vapor.Application) async throws {
  let apiMiddleware = ApiMiddleware.liveValue
  let baseUrl = configureBaseURL(app)
  await configureVaporMiddleware(app)
  let siteRouter = configureSiteRouter(app, baseUrl: baseUrl)
  let siteMiddleware = configureSiteMiddleware(apiMiddleware: apiMiddleware)
  app.mount(siteRouter, use: siteMiddleware.respond)
}

// Configure the base url for the application / router.
private func configureBaseURL(_ app: Vapor.Application) -> String {
  //  @Dependency(\.logger) var logger

  let baseURL: String =
    Environment.get("BASE_URL")
    ?? (app.environment == .production
      ? "http://localhost:8080"
      : "http://localhost:8080")

  //  logger.debug("Base URL: \(baseURL)")

  return baseURL
}

// Configure the vapor middleware.
private func configureVaporMiddleware(_ app: Vapor.Application) async {
  //  @Dependency(\.logger) var logger: Logger

  //  logger.info("Bootstrapping vapor middleware.")

  let corsConfiguration = CORSMiddleware.Configuration(
    allowedOrigin: .all,
    allowedMethods: [.GET, .POST, .PUT, .OPTIONS, .DELETE, .PATCH],
    allowedHeaders: [
      .accept, .authorization, .contentType, .origin, .xRequestedWith, .userAgent,
      .accessControlAllowOrigin,
    ]
  )
  let cors = CORSMiddleware(configuration: corsConfiguration)
  // cors middleware should come before default error middleware using `at: .beginning`
  app.middleware.use(cors, at: .beginning)

  //  let fileMiddleware = FileMiddleware(publicDirectory: app.directory.publicDirectory)
  //  app.middleware.use(fileMiddleware)
}

private func configureSiteRouter(_ app: Vapor.Application, baseUrl: String) -> AnyParserPrinter<
  URLRequestData, ServerRoute
> {
  @Dependency(\.siteRouter) var siteRouter

  return siteRouter.baseURL(baseUrl).eraseToAnyParserPrinter()
}

private func configureSiteMiddleware(
  apiMiddleware: ApiMiddleware
)
  -> SiteMiddleware
{
  return .live(apiMiddleware: apiMiddleware)
}
