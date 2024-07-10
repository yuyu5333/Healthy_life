/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License,Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { AchievementDialog } from './AchievementDialog';
import { TaskDetailDialog } from './TaskDetailDialog';
import { BroadCast, BroadCastType } from '../../common/utils/BroadCast';
import { TaskItem } from '../../model/TaskInitList';
import TaskInfo from '../../viewmodel/TaskInfo';
import Logger from '../../common/utils/Logger';
import AchievementInfo from '../../viewmodel/AchievementInfo';
///添加了东西

export class CustomDialogCallback {
  confirmCallback: Function = () => {
  };
  cancelCallback: Function = () => {
  };
}

@Component
export struct DeviceCustomDialogView {
  @State isShow: boolean = false;
  @Provide achievementLevel: number = 0;
  @Provide isAchievement: number = 1;
  @Provide singleTask: TaskInfo = TaskItem;
  //上面的变量是用来整成就显示的，添加了

  @Consume broadCast: BroadCast;
  @Provide currentTask: TaskInfo = TaskItem;
  @Provide dialogCallBack: CustomDialogCallback = new CustomDialogCallback();
  // achievement dialog
  achievementDialog: CustomDialogController = new CustomDialogController({
    builder: AchievementDialog(),
    autoCancel: true,
    customStyle: true
  });
  // task clock dialog
  taskDialog: CustomDialogController = new CustomDialogController({
    builder: TaskDetailDialog(),
    autoCancel: true,
    customStyle: true
  });

  aboutToAppear() {
    Logger.debug('CustomDialogView', 'aboutToAppear');
    // achievement dialog
    this.broadCast.on(BroadCastType.SHOW_ACHIEVEMENT_DIALOG,
      // (achievementLevel: number, isAchievement: number, task : TaskInfo)//原本只有一个achievementlevel
      (res: AchievementInfo) => {
        Logger.debug('CustomDialogView', 'SHOW_ACHIEVEMENT_DIALOG');
        this.achievementLevel = res.showAchievement? res.achievementLevel:res.lastTaskInfo.taskID;
        this.isAchievement = res.showAchievement? 1:0;
        this.singleTask =res.lastTaskInfo;
        this.achievementDialog.open();
      });

    // task clock dialog
    this.broadCast.on(BroadCastType.SHOW_TASK_DETAIL_DIALOG,
      (currentTask: TaskInfo, dialogCallBack: CustomDialogCallback) => {
        Logger.debug('CustomDialogView', 'SHOW_TASK_DETAIL_DIALOG');
        this.currentTask = currentTask || TaskItem;
        this.dialogCallBack = dialogCallBack;
        this.taskDialog.open();
      });
  }

  aboutToDisappear() {
    Logger.debug('CustomDialogView', 'aboutToDisappear');
  }

  build() {
  }
}