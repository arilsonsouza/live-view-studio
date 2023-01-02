defmodule LiveViewStudioWeb.DesksLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Desks
  alias LiveViewStudio.Desks.Desk

  def mount(_params, _session, socket) do
    if connected?(socket), do: Desks.subscribe()

    desks = Desks.list_desks()
    changeset = Desks.change_desk(%Desk{})

    socket =
      socket
      |> assign(desks: desks, changeset: changeset)
      |> allow_upload(:photo,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 3,
        max_file_size: 4_000_000
        # external: &generate_metadata/2
      )

    {:ok, socket, temporary_assigns: [desks: []]}
  end

  def handle_event("save", %{"desk" => params}, socket) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        # Path.join(s3_url(), filename(entry))
        Routes.static_path(socket, "/uploads/#{filename(entry)}")
      end

    desk = %Desk{photo_urls: urls}

    case Desks.create_desk(desk, params, &consume_photos(socket, &1)) do
      {:ok, _desk} ->
        changeset = Desks.change_desk(%Desk{})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"desk" => params}, socket) do
    changeset =
      %Desk{}
      |> Desks.change_desk(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  def handle_info({:desk_created, desk}, socket) do
    {:noreply, update(socket, :desks, fn desks -> [desk | desks] end)}
  end

  defp consume_photos(socket, desk) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
    end)

    {:ok, desk}
  end

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end

  # @s3_bucket "liveview-uploads"

  # defp s3_url, do: "//#{@s3_bucket}.s3.amazonaws.com"

  # defp generate_metadata(entry, socket) do
  #   config = %{
  #     region: "us-east-1",
  #     access_key_id: System.get_env("AWS_ACCESS_KEY_ID", "test"),
  #     secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY", "test")
  #   }

  #   {:ok, fields} =
  #     SimpleS3Upload.sign_form_upload(config, @s3_bucket,
  #       key: filename(entry),
  #       content_type: entry.client_type,
  #       max_file_size: socket.assigns.uploads.photo.max_file_size,
  #       expires_in: :timer.hours(1)
  #     )

  #   metadata = %{
  #     uploader: "S3",
  #     key: filename(entry),
  #     url: s3_url(),
  #     fields: fields
  #   }

  #   {:ok, metadata, socket}
  # end
end
