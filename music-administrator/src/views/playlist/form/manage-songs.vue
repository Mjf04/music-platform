<script setup lang="ts">
import { ref, watch } from "vue";
import { ElMessage } from "element-plus";
import {
  getSongsInPlaylist,
  addSongsToPlaylist,
  removeSongFromPlaylist,
  clearPlaylistSongs,
  getAllArtistsForSelect,
  getAllSongsForSelect
} from "@/api/system";

interface Props {
  visible: boolean;
  playlistId: number;
  playlistTitle: string;
}

const props = defineProps<Props>();
const emit = defineEmits(["update:visible", "success"]);

const dialogVisible = ref(false);
const loading = ref(false);
const artistList = ref([]);
const songList = ref([]);
const selectedArtistId = ref(null);
const currentPlaylistSongs = ref([]);
const selectedSongIds = ref([]);

watch(
  () => props.visible,
  val => {
    console.log("manage-songs watch triggered, visible:", val);
    dialogVisible.value = val;
    if (val && props.playlistId) {
      console.log("Loading playlist songs for playlistId:", props.playlistId);
      loadPlaylistSongs();
      loadArtists();
    }
  }
);

watch(dialogVisible, val => {
  emit("update:visible", val);
});

async function loadPlaylistSongs() {
  try {
    const res = await getSongsInPlaylist(props.playlistId);
    if (res.code === 0) {
      currentPlaylistSongs.value = res.data || [];
    }
  } catch (error) {
    console.error("加载歌单歌曲失败：", error);
  }
}

async function loadArtists() {
  try {
    const res = await getAllArtistsForSelect();
    if (res.code === 0 && res.data?.items) {
      artistList.value = res.data.items;
    }
  } catch (error) {
    console.error("加载歌手列表失败：", error);
  }
}

async function handleArtistChange() {
  if (!selectedArtistId.value) {
    songList.value = [];
    return;
  }

  loading.value = true;
  try {
    const res = await getAllSongsForSelect(selectedArtistId.value);
    if (res.code === 0 && res.data?.items) {
      songList.value = res.data.items;
    }
  } catch (error) {
    console.error("加载歌曲列表失败：", error);
    ElMessage.error("加载歌曲列表失败");
  } finally {
    loading.value = false;
  }
}

function isSongInPlaylist(songId: number) {
  return currentPlaylistSongs.value.some((song: any) => song.songId === songId);
}

async function handleAddSongs() {
  if (selectedSongIds.value.length === 0) {
    ElMessage.warning("请先选择要添加的歌曲");
    return;
  }

  try {
    const res = await addSongsToPlaylist(props.playlistId, selectedSongIds.value);
    if (res.code === 0) {
      ElMessage.success("添加歌曲成功");
      selectedSongIds.value = [];
      await loadPlaylistSongs();
      emit("success");
    } else {
      ElMessage.error(res.message || "添加歌曲失败");
    }
  } catch (error) {
    console.error("添加歌曲失败：", error);
    ElMessage.error("添加歌曲失败");
  }
}

async function handleRemoveSong(songId: number, songName: string) {
  try {
    const res = await removeSongFromPlaylist(props.playlistId, songId);
    if (res.code === 0) {
      ElMessage.success(`已移除歌曲：${songName}`);
      await loadPlaylistSongs();
      emit("success");
    } else {
      ElMessage.error(res.message || "移除歌曲失败");
    }
  } catch (error) {
    console.error("移除歌曲失败：", error);
    ElMessage.error("移除歌曲失败");
  }
}

async function handleClearAll() {
  try {
    const res = await clearPlaylistSongs(props.playlistId);
    if (res.code === 0) {
      ElMessage.success("已清空歌单");
      await loadPlaylistSongs();
      emit("success");
    } else {
      ElMessage.error(res.message || "清空歌单失败");
    }
  } catch (error) {
    console.error("清空歌单失败：", error);
    ElMessage.error("清空歌单失败");
  }
}

function handleClose() {
  selectedSongIds.value = [];
  selectedArtistId.value = null;
  songList.value = [];
  dialogVisible.value = false;
}
</script>

<template>
  <el-dialog
    v-model="dialogVisible"
    :title="`管理歌单：${playlistTitle}`"
    width="70%"
    :close-on-click-modal="false"
    @close="handleClose"
  >
    <div class="playlist-song-manager">
      <el-row :gutter="20">
        <el-col :span="12">
          <div class="section">
            <h3>添加歌曲</h3>
            <el-form label-width="80px">
              <el-form-item label="选择歌手">
                <el-select
                  v-model="selectedArtistId"
                  placeholder="请选择歌手"
                  clearable
                  class="w-full"
                  @change="handleArtistChange"
                >
                  <el-option
                    v-for="artist in artistList"
                    :key="artist.artistId"
                    :label="artist.artistName"
                    :value="artist.artistId"
                  />
                </el-select>
              </el-form-item>
            </el-form>

            <div v-if="songList.length > 0" class="song-list">
              <el-table
                :data="songList"
                height="400"
                @selection-change="val => (selectedSongIds = val.map((s: any) => s.songId))"
              >
                <el-table-column type="selection" width="55" />
                <el-table-column prop="songName" label="歌曲名" min-width="120" />
                <el-table-column prop="album" label="专辑" min-width="120" />
                <el-table-column label="状态" width="80">
                  <template #default="{ row }">
                    <el-tag v-if="isSongInPlaylist(row.songId)" type="success" size="small">
                      已添加
                    </el-tag>
                    <el-tag v-else type="info" size="small">未添加</el-tag>
                  </template>
                </el-table-column>
              </el-table>
              <el-button
                type="primary"
                class="mt-4 w-full"
                :disabled="selectedSongIds.length === 0"
                @click="handleAddSongs"
              >
                添加选中的歌曲 ({{ selectedSongIds.length }})
              </el-button>
            </div>
            <el-empty v-else description="请先选择歌手查看歌曲" />
          </div>
        </el-col>

        <el-col :span="12">
          <div class="section">
            <h3>
              歌单中的歌曲 ({{ currentPlaylistSongs.length }})
              <el-button
                v-if="currentPlaylistSongs.length > 0"
                type="danger"
                size="small"
                text
                @click="handleClearAll"
              >
                清空全部
              </el-button>
            </h3>
            <div v-if="currentPlaylistSongs.length > 0" class="current-songs">
              <el-table :data="currentPlaylistSongs" height="450">
                <el-table-column prop="songName" label="歌曲名" min-width="120" />
                <el-table-column prop="album" label="专辑" min-width="120" />
                <el-table-column label="操作" width="80" fixed="right">
                  <template #default="{ row }">
                    <el-button
                      type="danger"
                      size="small"
                      link
                      @click="handleRemoveSong(row.songId, row.songName)"
                    >
                      移除
                    </el-button>
                  </template>
                </el-table-column>
              </el-table>
            </div>
            <el-empty v-else description="歌单中暂无歌曲" />
          </div>
        </el-col>
      </el-row>
    </div>

    <template #footer>
      <el-button @click="handleClose">关闭</el-button>
    </template>
  </el-dialog>
</template>

<style scoped lang="scss">
.playlist-song-manager {
  .section {
    h3 {
      margin-bottom: 16px;
      font-size: 16px;
      font-weight: 600;
      display: flex;
      justify-content: space-between;
      align-items: center;
    }

    .song-list,
    .current-songs {
      margin-top: 16px;
    }
  }
}
</style>
