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
import AchievementMapInfo from '../viewmodel/AchievementMapInfo';
import TaskInfo from '../viewmodel/TaskInfo';
import { CommonConstants as Const } from '../common/constants/CommonConstants';

export interface ITaskItem {
  taskID: number;
  taskName: Resource;
  isOpen: boolean;
  isDone?: boolean; // bug1.新增
  unit: string;
  icon: Resource;
  dialogBg: Resource;
  targetValue: string;
  finValue?: string; // bug2.新增
  isAlarm: boolean;
  startTime: string;
  endTime: string;
  frequency: string;
  isInit: boolean;
  step: number;
}

export interface RemindContentItem {
  title: string;
  content: string;
}

export interface FrequencyContentType {
  id: number,
  label: string,
  isChecked: boolean
}

export const TaskList: TaskInfo[] = [
  new TaskInfo(0, '', 1, '7:00', true, '', ';', '', false, '', true),
  new TaskInfo(1, '', 2, '1.5', true, '', ';', '', false, '', true),
  new TaskInfo(2, '', 3, '3', true, '08: 00', '', '', false, '', true),
  new TaskInfo(3, '', 4, '1', true, '', ';', '', false, '', true),
  new TaskInfo(4, '', 5, '21:30', true, '', ';', '', false, '', true),
  new TaskInfo(5, '', 6, '22:00', true, '', ';', '', false, '', true)
]

let achievementMap = new AchievementMapInfo();

export const AchievementMap = achievementMap;

export const TaskMapById: Array<ITaskItem> = [
  {
    taskID: 1,
    taskName: $r('app.string.task_morning'),
    icon: $r("app.media.ic_task_morning"),
    dialogBg: $r('app.media.ic_dialog_getup'),
    targetValue: '', // 清除默认初始值
    isOpen: false,
    unit: '',
    step: 0,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: '1, 2, 3, 4, 5, 6, 7'
  },
  {
    taskID: 2,
    taskName: $r('app.string.task_water'),
    icon: $r("app.media.ic_task_water"),
    dialogBg: $r('app.media.ic_dialog_drink'),
    targetValue: '',
    isOpen: false,
    unit: 'L',
    step: 0.5,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: '1, 2, 3, 4, 5, 6, 7'
  },
  {
    taskID: 3,
    taskName: $r('app.string.task_apple'),
    icon: $r("app.media.ic_task_apple"),
    dialogBg: $r('app.media.ic_dialog_eat_apples'),
    targetValue: '',
    isOpen: false,
    unit: '个',
    step: 1,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: '1, 2, 3, 4, 5, 6, 7'
  },
  {
    taskID: 4,
    taskName: $r('app.string.task_smile'),
    icon: $r("app.media.ic_task_smile"),
    dialogBg: $r('app.media.ic_dialog_smile'),
    targetValue: '',
    isOpen: false,
    unit: '次',
    step: 0,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: '1, 2, 3, 4, 5, 6, 7'
  },
  {
    taskID: 5,
    taskName: $r('app.string.task_brush'),
    icon: $r("app.media.ic_task_brush"),
    dialogBg: $r('app.media.ic_dialog_brush_teeth'),
    targetValue: '',
    isOpen: false,
    unit: '次',
    step: 0,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: '1, 2, 3, 4, 5, 6, 7'
  },
  {
    taskID: 6,
    taskName: $r('app.string.task_night'),
    icon: $r("app.media.ic_task_night"),
    dialogBg: $r('app.media.ic_dialog_sleep'),
    targetValue: '',
    isOpen: false,
    unit: '',
    step: 0,
    isInit: true,
    isAlarm: false,
    startTime: '08: 00',
    endTime: '00: 00',
    frequency: ''
  }
]

export const TaskItem = new TaskInfo(1, '', 0, '7:00', true, 'string', 'string;', '', false, '6:58', false);

export const RemindContentMap: Array<RemindContentItem> = [
  {
    title: Const.GET_UP_TASK_NAME,
    content: Const.GET_UP_CONTENT
  },
  {
    title: Const.DRINK_TASK_NAME,
    content: Const.DRINK_CONTENT
  },
  {
    title: Const.EAT_APPLE_TASK_NAME,
    content: Const.EAT_APPLE_CONTENT
  },
  {
    title: Const.SMILE_TASK_NAME,
    content: Const.SMILE_CONTENT
  },
  {
    title: Const.BRUSH_TEETH_TASK_NAME,
    content: Const.BRUSH_TEETH_CONTENT
  },
  {
    title: Const.SLEEP_TASK_NAME,
    content: Const.SLEEP_CONTENT
  }
];

export const ACHIEVEMENT_LEVEL_LIST = [3, 7, 30, 50, 73, 99];