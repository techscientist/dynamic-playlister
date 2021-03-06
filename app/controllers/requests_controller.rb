class RequestsController < ApplicationController
  def destroy
    request = Request.find(params[:request_id])
    broadcast_information = { :request_id => "#{request.id}", :request_song_uid => "#{request.song.uid}" }
    request.destroy
    FayeServer.broadcast("/playlists/#{request.playlist.id}/delete", broadcast_information)
    render :nothing => true
  end

  def arrange
    video_ids = params[:video_ids]
    playlist = Playlist.find(params[:playlist_id])
    playlist.update_position(video_ids)
    broadcast_information = { :video_ids => params[:video_ids],
                                               :songs_array => params[:songs_array], 
                                               :current_video_index => params[:current_video_index]
                                             }
    FayeServer.broadcast("/playlists/#{playlist.id}/arrange", broadcast_information)
    render :nothing => true
  end
end
