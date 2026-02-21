package uk.co.willdale.starwarsapp.Networking

import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import uniffi.starwars.HttpClient
import uniffi.starwars.NetworkException
import java.net.HttpURLConnection
import java.net.SocketTimeoutException
import java.net.URL

class HttpClientAndroid : HttpClient {
    override suspend fun fetch(url: String): ByteArray = withContext(Dispatchers.IO) {
        val connection = URL(url).openConnection() as HttpURLConnection
        try {
            connection.requestMethod = "GET"
            connection.connectTimeout = 5000
            connection.readTimeout = 5000

            val responseCode = connection.responseCode
            if (responseCode in 200..299) {
                connection.inputStream.use { it.readBytes() }
            } else {
                throw NetworkException.RequestFailed(reason = "HTTP error: $responseCode")
            }
        } catch (e: NetworkException) {
            throw e  // let UniFFI-mapped exceptions pass through untouched
        } catch (e: SocketTimeoutException) {
            throw NetworkException.Timeout()
        } catch (e: Exception) {
            throw NetworkException.RequestFailed(reason = e.message ?: "Unknown error")
        } finally {
            connection.disconnect()
        }
    }
}