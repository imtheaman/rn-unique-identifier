import {TurboModule, TurboModuleRegistry} from 'react-native';

export interface Spec extends TurboModule {
    getPersistentIdentifier(): string
}

export default TurboModuleRegistry.get<Spec>(
  'RTNUniqueIdentifier',
) as Spec | null;
