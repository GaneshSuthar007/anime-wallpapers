package app.anime.wallpapers.network

import androidx.lifecycle.LiveData
import app.anime.wallpapers.network.data.BaseResponse
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow
import kotlinx.coroutines.flow.flowOn
import retrofit2.Response
import androidx.lifecycle.liveData
import java.net.UnknownHostException

abstract class BaseDataSource {

    protected suspend fun <T> getResult(tag: String, call: suspend () -> Response<BaseResponse<T>>): Resource<BaseResponse<T>> {
        try {
            val response = call()
            when (response.code()) {
                200 -> {
                    return Resource.success(tag, response.body()!!)
                }
                400 -> {
                    return Resource.error(tag, "oops page that you request not found.")
                }
                404 -> {
                    return Resource.error(tag, "oops page that you request is not found.")
                }
                500 -> {
                    return Resource.error(tag, "Server not responding.")
                }
                else -> {
                    response.errorBody()?.let {
                        return Resource.error(tag, response.errorBody().toString())
                    }
                    return Resource.error(tag, "Unknown error.")
                }
            }
        } catch (e: Exception) {
            e.printStackTrace()
            if(e is UnknownHostException){
                return Resource.noConnection(tag, "No internet connection.")
            }
            return Resource.error(tag, e.message ?: e.toString())
        }
    }

    fun <T> performFlowOperation(tag: String, networkCall: suspend () -> Resource<T>): Flow<Resource<T?>> = flow {
        try {
            emit(Resource.loading(tag, data = null))
            val responseStatus = networkCall.invoke()
            emit(responseStatus)
        } catch (e: Exception) {
            if(e is UnknownHostException){
                emit(Resource.noConnection(tag, "No internet connection."))
            }else{
                emit(Resource.error<T>(tag, e.message ?: e.toString()))
            }
        }
    }.flowOn(Dispatchers.Main)

    fun <T> performOperation(tag: String, networkCall: suspend () -> Resource<T>): LiveData<Resource<T?>> = liveData(Dispatchers.IO) {
        try {
            emit(Resource.loading(tag, data = null))
            val responseStatus = networkCall.invoke()
            emit(responseStatus)
        } catch (e: Exception) {
            if(e is UnknownHostException){
                emit(Resource.noConnection(tag, "No internet connection."))
            }else{
                emit(Resource.error<T>(tag, e.message ?: e.toString()))
            }
        }
    }

    data class Resource<out T>(val status: Status, val data: T?, val message: String?, val tag: String) {
        enum class Status {
            SUCCESS,
            ERROR,
            LOADING,
            CONNECTION
        }

        companion object {
            fun <T> success(tag: String, data: T): Resource<T> {
                return Resource(Status.SUCCESS, data, null, tag)
            }

            fun <T> error(tag: String, message: String?): Resource<T> {
                return Resource(Status.ERROR, null, message, tag)
            }

            fun <T> noConnection(tag: String, message: String?): Resource<T> {
                return Resource(Status.CONNECTION, null, message, tag)
            }

            fun <T> loading(tag: String, data: T? = null): Resource<T> {
                return Resource(Status.LOADING, data, null, tag)
            }
        }
    }

}

