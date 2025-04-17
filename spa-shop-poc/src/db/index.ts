import { createRxDatabase, addRxPlugin } from 'rxdb';
import { getRxStorageDexie } from 'rxdb/plugins/storage-dexie';
// Import your schemas here
// import { userSchema } from './schemas/userSchema';

export const setupDatabase = async () => {
  const db = await createRxDatabase({
    name: 'my_spa_db',
    storage: getRxStorageDexie(),
  });
  
  // Add your collections here
  // const collections = await db.addCollections({
  //   users: {
  //     schema: userSchema
  //   }
  // });
  
  return db;
};

export default setupDatabase;
