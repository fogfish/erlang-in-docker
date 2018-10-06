-module(APP).

-export([main/1]).


%%
%%
main(_) ->
   serverless:spawn(fun identity/1).   


%%
%%
-spec identity(map()) -> datum:either(map()).

identity(Json) ->
   {ok, Json}.
